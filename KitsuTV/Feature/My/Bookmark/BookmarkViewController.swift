//
//  BookmarkViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class BookmarkViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  private let bookmarkViewModel: BookmarkViewModel = BookmarkViewModel()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTableView()
    self.bindViewModel()
    self.loadData()
  }
  
  private func setupTableView() {
    self.registerTableViewCell()
    self.configureDelegates()
  }
  
  private func registerTableViewCell() {
    self.tableView.register(
      UINib(nibName: "BookmarkCell", bundle: nil),
      forCellReuseIdentifier: BookmarkCell.identifier
    )
  }
  
  private func configureDelegates() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  // MARK: - UI Updates
  private func bindViewModel() {
    self.bookmarkViewModel.dataChanged = { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  /// 데이터 로딩 시작
  private func loadData() {
    self.bookmarkViewModel.request()
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookmarkViewModel.channels?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = dequeueBookmarkCell(for: indexPath)
    self.configureCell(cell, at: indexPath)
    
    return cell
  }
  
  // MARK: - Cell Configuration
  /// BookmarkCell을 dequeue하여 반환
  /// - Parameter indexPath: 셀의 위치
  /// - Returns: 설정된 BookmarkCell
  private func dequeueBookmarkCell(for indexPath: IndexPath) -> UITableViewCell {
    return self.tableView.dequeueReusableCell(
      withIdentifier: BookmarkCell.identifier,
      for: indexPath
    )
  }
  
  /// 셀에 데이터 설정
  /// - Parameters:
  ///   - cell: 설정할 셀
  ///   - indexPath: 셀의 위치
  private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
    guard let bookmarkCell = cell as? BookmarkCell,
          let channelData = self.bookmarkViewModel.channels?[indexPath.row] else {
      return
    }
    
    bookmarkCell.setData(channelData)
  }
}
