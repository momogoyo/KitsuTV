//
//  FavoriteViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class FavoriteViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private var favoriteViewModel: FavoriteViewModel = FavoriteViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(
      UINib(nibName: VideoListItemCell.identifier, bundle: nil),
      forCellReuseIdentifier: VideoListItemCell.identifier
    )
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.favoriteViewModel.dataChanged = { [weak self] in
      self?.tableView.reloadData()
    }
    
    self.favoriteViewModel.request()
  }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.favoriteViewModel.favorite?.list.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(
      withIdentifier: VideoListItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? VideoListItemCell,
       let data = self.favoriteViewModel.favorite?.list[indexPath.row] {
      cell.setData(data, rank: nil)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    VideoListItemCell.height
  }
}

