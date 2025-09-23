//
//  PlayerView.swift
//  KitsuTV
//
//  Created by 현유진 on 9/22/25.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: AnyObject {
  func playerViewLoading(_ playerView: PlayerView)
  // 재생 준비 완료, 데이터 로드 완료 - 토탈 플레이 타임 업데이트해줄 수 있도록
  func playerViewReadyToPlay(_ playerView: PlayerView)
  func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double)
  // 영상이 끝나는 타이밍
  func playerViewDidFinishToPlay(_ playerView: PlayerView)
}

class PlayerView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupNotification()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.setupNotification()
  }
  
  // CALayer 대신 다른 Layer를 쓸 수 있게 해주는 클래스 프로퍼티
  override class var layerClass: AnyClass {
    // 뷰가 생성될 때 AVPlayerLayer 인스턴스가 만들어짐
    return AVPlayerLayer.self
  }
  
  // 편리한 접근 프로퍼티
  var avPlayerLayer: AVPlayerLayer? {
    // 깨진 유리창처럼 이렇게 확실한 경우에도 !를 쓰면 나도 모르게 크래시가 날 수 있기 때문에 가능하면 지양한다.
    return self.layer as? AVPlayerLayer
  }
  
  private var playObservation: Any?
  private var statusObservation: NSKeyValueObservation?
  
  weak var delegate: PlayerViewDelegate?
  
  var player: AVPlayer? {
    get {
      self.avPlayerLayer?.player
    }
    set {
      if let oldPlayer = self.avPlayerLayer?.player {
        self.unsetPlayer(player: oldPlayer)
      }
      
      self.avPlayerLayer?.player = newValue
      
      if let player = newValue {
        self.setup(player: player)
      }
    }
  }
  
  func set(url: URL) {
    self.delegate?.playerViewLoading(self)
    
    self.player = AVPlayer(
      playerItem: AVPlayerItem(
        asset: AVURLAsset(url: url)
      )
    )
  }
  
  var isPlaying: Bool {
    guard let player else {
      return false
    }
    
    return player.rate != 0
  }
  
  var totalPlayTime: Double {
    return self.player?.currentItem?.duration.seconds ?? 0
  }
  
  func play() {
    self.player?.play()
  }
  
  func pause() {
    self.player?.pause()
  }
  
  func seek(to percent: Double) {
    self.player?.seek(
      to: CMTime(seconds: percent * self.totalPlayTime, preferredTimescale: 1)
    )
  }
  
  func forward(to second: Double = 10) {
    guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }
    
    self.player?.seek(
      to: CMTime(seconds: currentTime + second, preferredTimescale: 1)
    )
  }
  
  func rewind(to second: Double = 10) {
    guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }
    
    self.player?.seek(
      to: CMTime(seconds: currentTime - second, preferredTimescale: 1)
    )
  }
}

extension PlayerView {
  private func setup(player: AVPlayer) {
    player.addPeriodicTimeObserver(
      forInterval: CMTime(seconds: 0.5, preferredTimescale: 10),
      queue: .main
    ) { [weak self, weak player] time in
      guard let self else { return }
      
      guard let currentItem = player?.currentItem,
            currentItem.status == .readyToPlay,
            let timeRange = (currentItem.loadedTimeRanges as? [CMTimeRange])?.first
      else { return }
      
      // 재생 가능한 구간의 끝지점 = 로드된 구간의 첫지점 + 로드된 구간의 길이
      let playableTime = timeRange.start.seconds + timeRange.duration.seconds
      let playTime = time.seconds
      
      self.delegate?.playerView(self, didPlay: playTime, playableTime: playableTime)
    }
    
    self.observePlayerStatus(player)
  }
  
  private func observePlayerStatus(_ player: AVPlayer) {
    self.statusObservation = player.currentItem?.observe(
      \.status,
       changeHandler: { [weak self] item, _ in
         guard let self else { return }
         
         switch item.status {
         case .readyToPlay:
           self.delegate?.playerViewReadyToPlay(self)
         case .failed:
           print("Failed to play \(item.error?.localizedDescription ?? "")")
         case .unknown:
           self.delegate?.playerViewLoading(self)
         default:
           print("Failed to play \(item.error?.localizedDescription ?? "")")
         }
       }
    )
  }
  
  private func unsetPlayer(player: AVPlayer) {
    self.statusObservation?.invalidate()
    self.statusObservation = nil
    
    if let playObservation {
      player.removeTimeObserver(playObservation)
    }
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.didPlayToEnd(_:)),
      name: .AVPlayerItemDidPlayToEndTime,
      object: nil
    )
  }
  
  @objc private func didPlayToEnd(_ notification: Notification) {
    self.delegate?.playerViewDidFinishToPlay(self)
  }
}
