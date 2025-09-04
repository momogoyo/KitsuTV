//
//  HomeVideoCell.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeVideoCell: UITableViewCell {
  
  static let identifier: String = "HomeVideoCell"
  static let height: CGFloat = 321
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  @IBOutlet weak var hotImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  @IBOutlet weak var channelImageView: UIImageView!
  @IBOutlet weak var channelTitleLabel: UILabel!
  @IBOutlet weak var channelSubtitleLabel: UILabel!
  
  // Storyboard에서 뷰가 로드된 직후 호출되는 메서드
  // @IBOutlet이 모두 연결된 상태에서 호출
  // 따라서 UI관련 초기화는 여기서 처리하는게 안전하다.
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.containerView.layer.cornerRadius = 10
    self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    self.containerView.layer.borderWidth = 1
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
