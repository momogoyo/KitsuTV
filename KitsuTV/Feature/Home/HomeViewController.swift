//
//  HomeViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  let homeViewModel = HomeViewModel()
  
  // MARK: - View Configuration
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupCollectionView()
    self.bindViewModel()
    
    self.homeViewModel.requestData()
  }
  
  // MARK: - Setup
  private func setupCollectionView() {
    self.registerSupplementaryViews()
    self.registerCells()
    self.configureDelegates()
    
    self.collectionView.isHidden = true
  }
  
  private func registerSupplementaryViews() {
    // Headers
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
    
    // Footers
    self.collectionView.register(
      UINib(nibName: "HomeFooterView", bundle: .main),
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: HomeFooterView.identifier
    )
  }
  
  private func registerCells() {
    self.collectionView.register(
      UINib(nibName: HomeVideoCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeVideoCell.identifier
    )
    self.collectionView.register(
      UINib(nibName: HomeRankingContainerCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeRankingContainerCell.identifier
    )
    self.collectionView.register(
      UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeRecentWatchContainerCell.identifier
    )
    self.collectionView.register(
      UINib(nibName: HomeRecommendContainerCell.identifier, bundle: .main),
      forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
    )
    
    self.collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "empty"
    )
  }
  
  private func configureDelegates() {
     self.collectionView.delegate = self
     self.collectionView.dataSource = self
   }
   
  
  private func bindViewModel() {
    self.homeViewModel.dataChanged = { [weak self] in
      self?.collectionView.isHidden = false
      self?.collectionView.reloadData()
    }
  }
  
  // MARK: - Navigation
  private func presentVideoViewController() {
    let videoViewController = VideoViewController()
    self.present(videoViewController, animated: true)
  }
  
  // MARK: - Helper Methods
  private func insetForSection(_ section: HomeSection) -> UIEdgeInsets {
    switch section {
    case .header, .footer:
      return .zero
    case .video, .ranking, .recentWatch, .recommend:
      return .init(top: 0, left: 21, bottom: 21, right: 21)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  // 섹션별 헤더 크기 설정
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
    case .video, .recentWatch, .recommend, .footer:
      return .zero
    }
  }
  
  // 섹션별 푸터 크기 설정
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let section = HomeSection(rawValue: section) else {
      return .zero
    }
    
    switch section {
    case .footer:
      return CGSize(width: collectionView.frame.width, height: HomeFooterView.height)
    case .header, .video, .ranking, .recentWatch, .recommend:
      return .zero
    }
  }
  
  // 섹션 여백 설정
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
  
  // 아이템 간 간격 설정
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header, .footer:
      return 0
    case .video, .ranking, .recentWatch, .recommend:
      return 21
    }
  }
  
  // 각 셀의 크기 설정
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
    case .header, .footer:
      return .zero
    case .video:
      return .init(width: width, height: HomeVideoCell.height)
    case .ranking:
      return .init(width: width, height: HomeRankingContainerCell.height)
    case .recentWatch:
      return .init(width: width, height: HomeRecentWatchContainerCell.height)
    case .recommend:
      return .init(width: width, height: HomeRecommendContainerCell.height(homeRecommendViewModel: self.homeViewModel.recommendViewModel))
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let section = HomeSection(rawValue: indexPath.section) else { return }
    
    switch section {
    case .header, .footer, .ranking, .recommend, .recentWatch:
      return ()
    case .video:
      self.presentVideoViewController()
    }
  }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    HomeSection.allCases.count
  }
  
  // 각 섹션의 아이템 개수 반환
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
    case .recentWatch:
      return 1
    case .recommend:
      return 1
    case .footer:
      return 0
    }
  }
  
  // 섹션별 헤더/푸터 뷰 생성 및 반환
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
    case .video, .recentWatch, .recommend:
      return .init()
    case .footer:
      return collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: HomeFooterView.identifier,
        for: indexPath
      )
    }
  }
  
  // 각 인덱스에 해당하는 셀 생성
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
    case .header, .footer:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: "empty",
        for: indexPath
      )
    case .video:
      return self.configureVideoCell(collectionView, indexPath: indexPath)
    case .ranking:
      return self.configureRankingCell(collectionView, indexPath: indexPath)
    case .recentWatch:
      return self.configureRecentWatchCell(collectionView, indexPath: indexPath)
    case .recommend:
      return self.configureRecommendCell(collectionView, indexPath: indexPath)
    }
  }
  
  // MARK: - Cell Configuration
  private func configureVideoCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeVideoCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeVideoCell,
       let data = self.homeViewModel.home?.videos[indexPath.item] {
      cell.setData(data)
    }
    
    return cell
  }
  
  private func configureRankingCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRankingContainerCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRankingContainerCell,
       let data = self.homeViewModel.home?.rankings {
      cell.setData(data)
      cell.delegate = self
    }
    
    return cell
  }
  
  private func configureRecentWatchCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRecentWatchContainerCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRecentWatchContainerCell,
       let data = self.homeViewModel.home?.recents {
      cell.delegate = self
      cell.setData(data)
    }
    
    return cell
  }
  
  private func configureRecommendCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeRecommendContainerCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRecommendContainerCell {
      cell.delegate = self
      cell.setViewModel(self.homeViewModel.recommendViewModel)
    }
    
    return cell
  }
}


// MARK: - HomeRecommendContainerCellDelegate
extension HomeViewController: HomeRecommendContainerCellDelegate {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
    self.presentVideoViewController()
  }
  
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
    self.collectionView.collectionViewLayout.invalidateLayout()
  }
}

// MARK: - HomeRankingContainerCellDelegate
extension HomeViewController: HomeRankingContainerCellDelegate {
  func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
    self.presentVideoViewController()
  }
}

// MARK: - HomeRecentWatchContainerCellDelegate
extension HomeViewController: HomeRecentWatchContainerCellDelegate {
  func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
    self.presentVideoViewController()
  }
}

