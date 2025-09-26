//
//  HomeRecentWatchItemCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/5/25.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRecentWatchItemCell"
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  // MARK: - Properties
  private var thumbnailImageViewTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupThumbnailImage()
  }
  
  private func setupThumbnailImage() {
    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.width / 2
    self.thumbnailImageView.layer.borderWidth = 2
    self.thumbnailImageView.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: Home.Recent) {
    configureContent(data)
    loadThumbnail(data.thumbnailImage)
  }
  
  private func configureContent(_ data: Home.Recent) {
    self.dateLabel.text = data.timeStamp.formattedTime
    self.titleLabel.text = data.title
    self.subtitleLabel.text = data.channel
  }
  
  private func loadThumbnail(_ url: URL) {
    self.thumbnailImageViewTask = self.thumbnailImageView.loadImage(url: url)
  }
}
