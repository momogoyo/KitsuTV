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
  
  private var imageTask: Task<Void, Never>?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.width / 2
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.label.text = nil
    self.thumbnailImageView.image = nil
    self.imageTask?.cancel()
    self.imageTask = nil
  }
  
  func setData(_ data: Bookmark.Item) {
    self.label.text = data.channel
    self.imageTask = self.thumbnailImageView.loadImage(url: data.thumbnail)
  }
}
