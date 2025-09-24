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
  
  weak var delegate: SeekBarViewDelegate?
  
  override func awakeFromNib() {
    self.totalPlayTimeView.layer.cornerRadius = 1
    self.playablePlayTimeView.layer.cornerRadius = 1
    self.currentPlayTimeView.layer.cornerRadius = 1
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
    return min(self.frame.width, self.frame.width * time / self.totalPlayTime)
  }
  
  // MARK: - PlayTime Configuration
  func setTotalPlayTime(_ totalPlayTime: Double) {
    self.totalPlayTime = totalPlayTime
    
    self.update()
  }
  
  func setPlayTime(_ playTime: Double, playableTime: Double) {
    self.currentPlayTime = playTime
    self.playableTime = playableTime
    
    self.update()
  }
}
