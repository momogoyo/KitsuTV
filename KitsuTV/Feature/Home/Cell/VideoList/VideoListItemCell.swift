//
//  VideoListItemCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class VideoListItemCell: UITableViewCell {
  
  static let identifier: String = "VideoListItemCell"
  static let height: CGFloat = 71
  
  // Rank
  @IBOutlet weak var rankLabel: UILabel!
  // Thumbnail
  @IBOutlet weak var thumbnailContainerView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var playTimeBGView: UIView!
  @IBOutlet weak var playTimeLabel: UILabel!
  // Content
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  // Layout
  @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
  
  private var imageTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupThumbnail()
    self.setupRankLabel()
    self.setupPlayTimeView()
    self.setupLayout()
    
    self.backgroundConfiguration = .clear()
  }
  
  private func setupThumbnail() {
    self.thumbnailImageView.layer.cornerRadius = 4
    self.thumbnailImageView.clipsToBounds = true
  }
  
  private func setupRankLabel() {
    self.rankLabel.layer.cornerRadius = 2
    self.rankLabel.clipsToBounds = true
    self.rankLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
  }
  
  private func setupPlayTimeView() {
    self.playTimeBGView.layer.cornerRadius = 2
  }
  
  private func setupLayout() {
    self.contentLeadingConstraint.constant = 0
  }
  
  // MARK: - Cell Configuration
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setData(_ data: VideoListItem, rank: Int?) {
    self.configureRank(rank)
    self.configureContent(data)
    self.loadThumbnail(data.imageUrl)
  }
  
  func setLeading(_ leading: CGFloat) {
    self.contentLeadingConstraint.constant = leading
  }
  
  // MARK: - Private Methods
  private func configureRank(_ rank: Int?) {
    self.rankLabel.isHidden = rank == nil
    if let rank {
      self.rankLabel.text = "\(rank)"
    }
  }
  
  private func configureContent(_ data: VideoListItem) {
    self.titleLabel.text = data.title
    self.descriptionLabel.text = data.channel
    self.playTimeLabel.text = data.playtime.timeFormatter
  }
  
  private func loadThumbnail(_ url: URL) {
    self.imageTask = self.thumbnailImageView.loadImage(url: url)
  }
}
