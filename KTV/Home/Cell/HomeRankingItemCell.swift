//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 현유진 on 9/4/25.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRankingItemCell"
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var numberLabel: UILabel!
  
  private var thumbnailImageViewTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 10
  }
  
  // 셀이 재사용 되기 전에 초기화 해주는 역할
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.numberLabel.text = nil
  }
  
  func setData(_ data: Home.Ranking, rank: Int) {
    self.numberLabel.text = "\(rank)"
    self.thumbnailImageViewTask = self.thumbnailImageView.loadImage(url: data.thumbnailImage)
  }
}
