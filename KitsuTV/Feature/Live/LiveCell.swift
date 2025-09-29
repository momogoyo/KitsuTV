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
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  // MARK: - Properties
  private var imageTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupLiveLabel()
    self.setupImageView()
  }
  
  private func setupLiveLabel() {
    self.liveLabel.layer.cornerRadius = 4
    self.liveLabel.clipsToBounds = true
  }
  
  private func setupImageView() {
    self.imageView.layer.cornerRadius = 4
  }
  
  // MARK: - Cell Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetContent()
  }
  
  private func resetContent() {
    self.imageTask?.cancel()
    self.imageTask = nil
    self.imageView.image = nil
    self.titleLabel.text = nil
    self.descriptionLabel.text = nil
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: Live.Item) {
    self.configureContent(data)
    self.loadThumbnail(data.thumbnailUrl)
  }
  
  private func configureContent(_ data: Live.Item) {
    self.titleLabel.text = data.title
    self.descriptionLabel.text = data.channel
  }
  
  private func loadThumbnail(_ url: URL) {
    self.imageTask = self.imageView.loadImage(url: url)
  }
}
