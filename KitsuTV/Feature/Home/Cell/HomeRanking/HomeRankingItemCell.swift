//
//  HomeRankingItemCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/4/25.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRankingItemCell"
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var numberLabel: UILabel!
  
  // MARK: - Properties
  private var thumbnailImageViewTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupThumbnail()
    self.setupNumberLabel()
  }
  
  private func setupThumbnail() {
    self.thumbnailImageView.layer.cornerRadius = 8
    self.thumbnailImageView.clipsToBounds = true
  }
  
  private func setupNumberLabel() {
    self.numberLabel.layer.cornerRadius = 4
    self.numberLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
    self.numberLabel.clipsToBounds = true
  }
  
  // MARK: - Cell Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetContent()
  }
  
  private func resetContent() {
    self.numberLabel.text = nil
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: Home.Ranking, rank: Int) {
    self.configureContent(data, rank: rank)
    self.loadThumbnail(data.thumbnailImage)
  }
  
  private func configureContent(_ data: Home.Ranking, rank: Int) {
    self.numberLabel.text = "\(rank)"
  }
  
  private func loadThumbnail(_ url: URL) {
    self.thumbnailImageViewTask = self.thumbnailImageView.loadImage(url: url)
  }
}
