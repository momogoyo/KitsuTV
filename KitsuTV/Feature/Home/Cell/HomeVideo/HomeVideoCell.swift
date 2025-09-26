//
//  HomeVideoCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeVideoCell: UICollectionViewCell {
  
  static let identifier: String = "HomeVideoCell"
  static let height: CGFloat = 300
  
  // Container
  @IBOutlet weak var containerView: UIView!
  // Video Content
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var hotImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  // Channel Content
  @IBOutlet weak var channelImageView: UIImageView!
  @IBOutlet weak var channelTitleLabel: UILabel!
  @IBOutlet weak var channelSubtitleLabel: UILabel!
  
  // MARK: - Properties
  private var thumbnailImageViewTask: Task<Void, Never>?
  private var channelImageViewTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupContainer()
    self.setupChannelImage()
  }
  
  private func setupContainer() {
    self.containerView.layer.cornerRadius = 12
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = UIColor(named: "border")?.cgColor
    self.containerView.clipsToBounds = true
  }
  
  private func setupChannelImage() {
    self.channelImageView.layer.cornerRadius = self.channelImageView.bounds.width / 2
  }
  
  // MARK: - Cell Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.cancelImageTasks()
    self.resetContent()
  }
  
  private func cancelImageTasks() {
    self.thumbnailImageViewTask?.cancel()
    self.thumbnailImageViewTask = nil
    self.channelImageViewTask?.cancel()
    self.channelImageViewTask = nil
  }
  
  private func resetContent() {
    self.thumbnailImageView.image = nil
    self.titleLabel.text = nil
    self.subtitleLabel.text = nil
    self.channelImageView.image = nil
    self.channelTitleLabel.text = nil
    self.channelSubtitleLabel.text = nil
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: Home.Video) {
    self.configureVideoContent(data)
    self.configureChannelContent(data)
    self.loadImages(data)
  }
  
  private func configureVideoContent(_ data: Home.Video) {
    self.titleLabel.text = data.title
    self.subtitleLabel.text = data.subtitle
    self.hotImageView.isHidden = !data.isHot
  }
  
  private func configureChannelContent(_ data: Home.Video) {
    self.channelTitleLabel.text = data.channel
    self.channelSubtitleLabel.text = data.channelDescription
  }
  
  private func loadImages(_ data: Home.Video) {
    self.thumbnailImageViewTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
    self.channelImageViewTask = self.channelImageView.loadImage(url: data.channelThumbnailURL)
  }
}
