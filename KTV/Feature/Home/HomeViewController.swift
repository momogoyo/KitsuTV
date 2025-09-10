//
//  HomeViewController.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeViewController: UIViewController {
  let homeViewModel = HomeViewModel()
  @IBOutlet weak var collectionView: UICollectionView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    bindViewModel()
    
    self.homeViewModel.requestData()
  }
  
  private func setupCollectionView() {
    // UICollectionReusableView
    self.collectionView.register(
      UINib(nibName: "HomeHeaderView", bundle: .main),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderView.identifier
    )
    self.collectionView.register(
      UINib(nibName: "HomeRankingHeaderView", bundle: .main),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeRankingHeaderView.identifier
    )
    
    self.collectionView.register(
      UINib(nibName: "HomeVideoCell", bundle: .main),
      forCellWithReuseIdentifier: HomeVideoCell.identifier
    )
    self.collectionView.register(
      UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: HomeRankingContainerCell.identifier
    )
    
    self.collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "empty"
    )
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    self.collectionView.isHidden = true
  }
  
  private func bindViewModel() {
    self.homeViewModel.dataChanged = { [weak self] in
      self?.collectionView.isHidden = false
      self?.collectionView.reloadData()
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    HomeSection.allCases.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header:
      return 0
    case .video:
      return self.homeViewModel.home?.videos.count ?? 0
    case .ranking:
      return 1
      //    case .recentWatch:
      //      return 1
      //    case .recommend:
      //      return 1
      //    case .footer:
      //      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return UICollectionReusableView()
    }
    
    switch section {
    case .header:
      return collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: HomeHeaderView.identifier,
        for: indexPath
      )
    case .ranking:
      return collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: HomeRankingHeaderView.identifier,
        for: indexPath
      )
    case .video:
      return .init()
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: "empty",
        for: indexPath
      )
    }
    
    switch section {
    case .header:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: "empty",
        for: indexPath
      )
    case .video:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeVideoCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeVideoCell,
         let data = self.homeViewModel.home?.videos[indexPath.item] {
        cell.setData(data)
      }
      
      return cell
    case .ranking:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeRankingContainerCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeRankingContainerCell,
         let data = self.homeViewModel.home?.rankings {
        print("Setting ranking data: \(data.count) items")
        cell.setData(data)
      }
      
      (cell as? HomeRankingContainerCell)?.delegate = self
      
      return cell
    }
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard let section = HomeSection(rawValue: section) else {
      return .zero
    }
    
    switch section {
    case .header:
      return CGSize(width: collectionView.frame.width, height: HomeHeaderView.height)
    case .ranking:
      return CGSize(width: collectionView.frame.width, height: HomeRankingHeaderView.height)
    case .video:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let section = HomeSection(rawValue: section) else {
      return .zero
    }
    
    switch section {
    case .header, .ranking, .video:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    guard let section = HomeSection(rawValue: section) else {
      return .zero
    }
    
    return self.insetForSection(section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header:
      return 0
    case .video, .ranking:
      return 21
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return .zero
    }
    
    let inset = self.insetForSection(section)
    let width = collectionView.frame.width - inset.left - inset.right
    
    switch section {
    case .header:
      return .zero
    case .video:
      return .init(width: width, height: HomeVideoCell.height)
    case .ranking:
      return .init(width: width, height: HomeRankingContainerCell.height)
    }
  }
  
  private func insetForSection(_ section: HomeSection) -> UIEdgeInsets {
    switch section {
    case .header:
      return .zero
    case .video, .ranking:
        return .init(top: 0, left: 21, bottom: 21, right: 21)
    }
  }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
    print("home recommend cell did select item at \(index)")
  }
  
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
    self.collectionView.collectionViewLayout.invalidateLayout()
  }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
    print("home ranking did select at \(index)")
  }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
  func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
    print("home recent watch did select at \(index)")
  }
}

