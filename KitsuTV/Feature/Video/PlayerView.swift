//
//  PlayerView.swift
//  KitsuTV
//
//  Created by 현유진 on 9/22/25.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
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
  
  var player: AVPlayer? {
    get {
      self.avPlayerLayer?.player
    }
    set {
      self.avPlayerLayer?.player = newValue
    }
  }
  
  func set(url: URL) {
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
