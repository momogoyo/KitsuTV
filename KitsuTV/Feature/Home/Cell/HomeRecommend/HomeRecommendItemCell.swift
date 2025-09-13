//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
  
  static let identifier: String = "HomeRecommendItemCell"
  static let height: CGFloat = 71
  
  @IBOutlet weak var thumbnailContainerView: UIView!
  @IBOutlet weak var rankLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var playTimeBGView: UIView!
  @IBOutlet weak var playTimeLabel: UILabel!
  
  private var imageTask: Task<Void, Never>?
  
  // xid로 만들어진 UI가 해당 class에 정상적으로 연동을 마쳤을 때 불려지는 함수
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.thumbnailImageView.layer.cornerRadius = 8
    self.thumbnailImageView.clipsToBounds = true
    self.rankLabel.layer.cornerRadius = 4
    self.rankLabel.clipsToBounds = true
    self.rankLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
    self.playTimeBGView.layer.cornerRadius = 4
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setData(_ data: Home.Recommend, rank: Int?) {
    self.rankLabel.isHidden = rank == nil
    if let rank {
      self.rankLabel.text = "\(rank)"
    }
    self.titleLabel.text = data.title
    self.descriptionLabel.text = data.channel
    self.imageTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
    self.playTimeLabel.text = data.playtime.timeFormatter
  }
}
