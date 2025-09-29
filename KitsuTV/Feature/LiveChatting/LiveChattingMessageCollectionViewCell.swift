//
//  LiveChattingMessageCollectionViewCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import UIKit

class LiveChattingMessageCollectionViewCell: UICollectionViewCell {
  
  static let identifier: String = "LiveChattingMessageCollectionViewCell"
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var textLabel: UILabel!
  
  private static let sizingCell = Bundle.main.loadNibNamed(
    "LiveChattingMessageCollectionViewCell",
    owner: nil
  )?.first(where: { $0 is LiveChattingMessageCollectionViewCell }) as? LiveChattingMessageCollectionViewCell
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
  }
  
  static func size(width: CGFloat, text: String) -> CGSize {
    Self.sizingCell?.setText(text)
    Self.sizingCell?.frame.size.width = width
    let fittingSize = Self.sizingCell?.systemLayoutSizeFitting(
      .init(width: width, height: UIView.layoutFittingExpandedSize.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    
    return fittingSize ?? .zero
  }
  
  private func setupUI() {
    self.bgView.layer.cornerRadius = 8
  }
  
  func setText(_ text: String) {
    self.textLabel.text = text
  }
}
