//
//  HomeViewController.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

class HomeViewController: UIViewController {
  
  let homeViewModel = HomeViewModel()
  @IBOutlet weak var tableView: UITableView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    bindViewModel()
    
    self.homeViewModel.requestData()
  }
  
  private func setupTableView() {
    self.tableView.register(
      UINib(nibName: HomeHeaderCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeHeaderCell.identifier
    )
    self.tableView.register(
      UINib(nibName: HomeVideoCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeVideoCell.identifier
    )
    self.tableView.register(
      UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeRecommendContainerCell.identifier
    )
    self.tableView.register(
      UINib(nibName: HomeFooterCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeFooterCell.identifier
    )
    
    // MARK: - Ranking View
    self.tableView.register(
      UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeRankingContainerCell.identifier
    )
    
    // MARK: - Recent Watch View
    self.tableView.register(
      UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
      forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier
    )
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "empty")
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  private func bindViewModel() {
    // TableView 동작 방식
    // 1. dataSource에게 몇개의 셀이 있는지 물어봄
    // 2. 각 셀에 뭘 보여줄까?라고 물어봄
    // 3. reloadData를 호출해야 다시 물어볼 수 있음
    self.homeViewModel.dataChanged = { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    HomeSection.allCases.count
  }
  
  // 각 section의 row 개수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = HomeSection(rawValue: section) else { return 0 }
    
    switch section {
    case .header:
      return 1
    case .video:
      return self.homeViewModel.home?.videos.count ?? 0
    case .ranking:
      return 1
    case .recentWatch:
      return 1
    case .recommend:
      return 1
    case .footer:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
    
    switch section {
    case .header:
      return HomeHeaderCell.height
    case .video:
      return HomeVideoCell.height
    case .ranking:
      return HomeRankingContainerCell.height
    case .recentWatch:
      return HomeRecentWatchContainerCell.height
    case .recommend:
      return HomeRecommendContainerCell.height
    case .footer:
      return HomeFooterCell.height
    }
  }
  
  // 셀 구성
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = HomeSection(rawValue: indexPath.section) else {
      return tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
    }
    
    switch section {
    case .header:
      return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
    case .video:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeVideoCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeVideoCell,
         let data = self.homeViewModel.home?.videos[indexPath.row] {
        cell.setData(data)
      }
      
      return cell
    case .ranking:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRankingContainerCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeRankingContainerCell,
         let data = self.homeViewModel.home?.rankings {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .recentWatch:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRecentWatchContainerCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeRecentWatchContainerCell,
         let data = self.homeViewModel.home?.recents {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .recommend:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: HomeRecommendContainerCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? HomeRecommendContainerCell,
         let data = self.homeViewModel.home?.recommends {
        cell.delegate = self
        cell.setData(data)
      }
      
      return cell
    case .footer:
      return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
    }
  }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
    print("home recommend cell did select item at \(index)")
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
