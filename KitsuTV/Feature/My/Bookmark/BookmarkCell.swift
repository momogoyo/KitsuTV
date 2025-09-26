//
//  BookmarkCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class BookmarkCell: UITableViewCell {
  
  static let identifier: String = "BookmarkCell"
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  // MARK: - Properties
  /// 이미지 로딩 작업을 관리하기 위한 Task (셀 재사용 시 취소 가능)
  private var imageTask: Task<Void, Never>?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupThumbnailImage()
  }
  
  private func setupThumbnailImage() {
    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.width / 2
  }
  
  // MARK: - Cell Life Cycle
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  /// 셀이 재사용되기 전 초기화 작업 수행
  /// - 텍스트와 이미지를 초기화하고 진행 중인 이미지 로딩 작업을 취소
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.resetContent()
    self.cancelImageLoading()
  }
  
  private func resetContent() {
    self.label.text = nil
    self.thumbnailImageView.image = nil
  }
  
  private func cancelImageLoading() {
    self.imageTask?.cancel()
    self.imageTask = nil
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: Bookmark.Item) {
    self.configureContent(data)
    self.loadThumbnail(data.thumbnail)
  }
  
  private func configureContent(_ data: Bookmark.Item) {
    self.label.text = data.channel
  }
  
  private func loadThumbnail(_ thumbnailURL: URL) {
    self.imageTask = self.thumbnailImageView.loadImage(url: thumbnailURL)
  }
}
