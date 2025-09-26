//
//  HomeRankingContainerCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/4/25.
//

import UIKit

// MARK: - HomeRankingContainerCellDelegate
protocol HomeRankingContainerCellDelegate: AnyObject {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int)
}

class HomeRankingContainerCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRankingContainerCell"
  static let height: CGFloat = 265
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  private var rankings: [Home.Ranking]?
  weak var delegate: HomeRankingContainerCellDelegate?
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupCollectionView()
  }
  
  private func setupCollectionView() {
    self.collectionView.register(
      UINib(nibName: HomeRankingItemCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: HomeRankingItemCell.identifier
    )
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  // MARK: - Cell Configuration
  func setData(_ data: [Home.Ranking]) {
    self.rankings = data
    self.collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension HomeRankingContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.rankings?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRankingItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRankingItemCell,
       let data = self.rankings?[indexPath.item] {
      cell.setData(data, rank: indexPath.item + 1)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
  }
}
