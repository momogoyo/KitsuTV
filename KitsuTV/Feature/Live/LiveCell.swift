//
//  LiveCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/28/25.
//

import UIKit

class LiveCell: UICollectionViewCell {
  
  static let identifier: String = "LiveCell"
  static let height: CGFloat = 76
  
  @IBOutlet weak var liveLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.liveLabel.layer.cornerRadius = 4
    self.liveLabel.clipsToBounds = true
    self.imageView.layer.cornerRadius = 4
  }
  
}
