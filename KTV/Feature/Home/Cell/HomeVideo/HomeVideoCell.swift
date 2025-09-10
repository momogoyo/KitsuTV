//
//  HomeVideoCell.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeVideoCell: UICollectionViewCell {
  
  static let identifier: String = "HomeVideoCell"
  static let height: CGFloat = 300
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var hotImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var channelImageView: UIImageView!
  @IBOutlet weak var channelTitleLabel: UILabel!
  @IBOutlet weak var channelSubtitleLabel: UILabel!
  
  private var thumbnailImageViewTask: Task<Void, Never>?
  private var channelImageViewTask: Task<Void, Never>?
  
  // Storyboard에서 뷰가 로드된 직후 호출되는 메서드
  // @IBOutlet이 모두 연결된 상태에서 호출
  // 따라서 UI관련 초기화는 여기서 처리하는게 안전하다.
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.containerView.layer.cornerRadius = 10
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    self.containerView.clipsToBounds = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.thumbnailImageViewTask?.cancel()
    self.thumbnailImageViewTask = nil
    self.channelImageViewTask?.cancel()
    self.channelImageViewTask = nil
    
    self.thumbnailImageView.image = nil
    self.titleLabel.text = nil
    self.subtitleLabel.text = nil
    self.channelImageView.image = nil
    self.channelTitleLabel.text = nil
    self.channelSubtitleLabel.text = nil
  }
  
  func setData(_ data: Home.Video) {
    self.titleLabel.text = data.title
    self.subtitleLabel.text = data.subtitle
    self.channelTitleLabel.text = data.channel
    self.channelSubtitleLabel.text = data.channelDescription
    self.hotImageView.isHidden = !data.isHot
    self.thumbnailImageViewTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
    self.channelImageViewTask = self.channelImageView.loadImage(url: data.channelThumbnailURL)
  }
}
