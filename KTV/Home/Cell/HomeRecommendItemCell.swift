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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.thumbnailContainerView.layer.cornerRadius = 5
    self.rankLabel.layer.cornerRadius = 5
    self.rankLabel.clipsToBounds = true
    self.playTimeBGView.layer.cornerRadius = 3
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
