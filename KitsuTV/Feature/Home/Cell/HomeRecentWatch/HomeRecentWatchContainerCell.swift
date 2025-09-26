//
//  HomeRecentWatchContainerCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/5/25.
//

import UIKit

// MARK: - HomeRecentWatchContainerCellDelegate
protocol HomeRecentWatchContainerCellDelegate: AnyObject {
  func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRecentWatchContainerCell"
  static let height: CGFloat = 189
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  private var recents: [Home.Recent]?
  weak var delegate: HomeRecentWatchContainerCellDelegate?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
    self.setupCollectionView()
  }
  
  private func setupUI() {
    self.collectionView.layer.cornerRadius = 12
    self.collectionView.layer.borderWidth = 1
    self.collectionView.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  private func setupCollectionView() {
    self.collectionView.register(
      UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
    )
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: [Home.Recent]) {
    self.recents = data
    self.collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension HomeRecentWatchContainerCell: UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.recents?.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRecentWatchItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRecentWatchItemCell,
       let data = self.recents?[indexPath.item] {
      cell.setData(data)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
