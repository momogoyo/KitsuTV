//
//  MoreTableViewCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
  
  static let identifier: String = "MoreTableViewCell"
  static let height: CGFloat = 48
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var separatorView: UIView!
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundConfiguration = .clear()
  }
  
  // MARK: - Cell Configuration
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setItem(_ item: MoreItem, separatorHidden: Bool) {
    self.titleLabel.text = item.title
    self.descriptionLabel.text = item.rightText
    self.separatorView.isHidden = separatorHidden
  }
}
