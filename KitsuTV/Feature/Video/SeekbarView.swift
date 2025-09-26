//
//  SeekbarView.swift
//  KitsuTV
//
//  Created by 현유진 on 9/24/25.
//

import UIKit

protocol SeekBarViewDelegate: AnyObject {
  func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double)
}

class SeekbarView: UIView {
  
  // MARK: - Progress Bar UI Components
  @IBOutlet weak var totalPlayTimeView: UIView!
  @IBOutlet weak var playablePlayTimeView: UIView!
  @IBOutlet weak var currentPlayTimeView: UIView!
  
  // MARK: - Progress Bar Constraints
  @IBOutlet weak var playableTimeWidth: NSLayoutConstraint!
  @IBOutlet weak var playTimeWidth: NSLayoutConstraint!
  
  // MARK: - Properties
  private(set) var totalPlayTime: Double = 0
  private(set) var playableTime: Double = 0
  private(set) var currentPlayTime: Double = 0
  private(set) var isDragging: Bool = false
  
  weak var delegate: SeekBarViewDelegate?
  
  override func awakeFromNib() {
    self.totalPlayTimeView.layer.cornerRadius = 1
    self.playablePlayTimeView.layer.cornerRadius = 1
    self.currentPlayTimeView.layer.cornerRadius = 1
  }
  
  // MARK: - Touch Event
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    guard let touch = touches.first else { return }
    self.isDragging = true
    self.updatePlayedWidth(touch: touch, notifyDelegate: false)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    
    guard let touch = touches.first else { return }
    self.isDragging = true
    self.updatePlayedWidth(touch: touch, notifyDelegate: false)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    guard let touch = touches.first else { return }
    self.isDragging = false
    self.updatePlayedWidth(touch: touch, notifyDelegate: true)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    
    guard let touch = touches.first else { return }
    self.isDragging = false
  }
  
  // MARK: - Update Time Seekbar UI
  private func update() {
    guard self.totalPlayTime > 0 else { return }
    
    self.playableTimeWidth.constant = self.widthForTime(self.playableTime)
    self.playTimeWidth.constant = self.widthForTime(self.currentPlayTime)
    
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }
  
  private func widthForTime(_ time: Double) -> CGFloat {
    min(self.frame.width, self.frame.width * time / self.totalPlayTime)
  }
  
  private func widthForTouch(_ touch: UITouch) -> CGFloat {
    min(touch.location(in: self).x, self.playableTimeWidth.constant)
  }
  
  private func updatePlayedWidth(touch: UITouch, notifyDelegate: Bool) {
    let xPosition = self.widthForTouch(touch)
    self.playTimeWidth.constant = xPosition
    
    if notifyDelegate {
      let percent = xPosition / self.frame.width
      self.delegate?.seekbar(self, seekToPercent: percent)
    }
  }
  
  // MARK: - PlayTime Configuration
  func setTotalPlayTime(_ totalPlayTime: Double) {
    self.totalPlayTime = totalPlayTime
    
    self.update()
  }
  
  func setPlayTime(_ playTime: Double, playableTime: Double) {
    guard !isDragging else { return }
      
    self.currentPlayTime = playTime
    self.playableTime = playableTime
    
    self.update()
    
  }
}
