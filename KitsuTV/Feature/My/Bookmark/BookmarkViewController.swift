//
//  BookmarkViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class BookmarkViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private let bookmarkViewModel: BookmarkViewModel = BookmarkViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(
      UINib(nibName: "BookmarkCell", bundle: nil),
      forCellReuseIdentifier: BookmarkCell.identifier
    )
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.bookmarkViewModel.dataChanged = { [weak self] in
      self?.tableView.reloadData()
    }
    
    self.bookmarkViewModel.request()
  }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    bookmarkViewModel.channels?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(
      withIdentifier: BookmarkCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? BookmarkCell,
       let data = self.bookmarkViewModel.channels?[indexPath.row] {
      cell.setData(data)
    }
    
    return cell
  }
}
