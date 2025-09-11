//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRecommendContainerCell"
  
  static func height(homeRecommendViewModel: HomeRecommendViewModel) -> CGFloat {
    let top: CGFloat = 84 - 16 // cell의 상단 여백
    let bottom: CGFloat = 68 - 6 // cell의 하단 여백
    let footerInset: CGFloat = 51 // container -> footer 까지의 여백
    
    return HomeRecommendItemCell.height * CGFloat(homeRecommendViewModel.itemCount) + top + bottom + footerInset
  }
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var foldButton: UIButton!
  weak var delegate: HomeRecommendContainerCellDelegate?
  
  private var homeRecommendViewModel: HomeRecommendViewModel?
  private var recommends: [Home.Recommend]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.containerView.layer.cornerRadius = 10
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    self.tableView.rowHeight = HomeRecommendItemCell.height
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(
      UINib(nibName: "HomeRecommendItemCell", bundle: .main),
      forCellReuseIdentifier: HomeRecommendItemCell.identifier
    )
  }
  
  @IBAction func foldButtonDidTap(_ sender: UIButton) {
    self.homeRecommendViewModel?.toggleFoldState()
    self.delegate?.homeRecommendContainerCellFoldChanged(self)
  }
  
  func setViewModel(_ homeRecommendViewModel: HomeRecommendViewModel) {
    self.homeRecommendViewModel = homeRecommendViewModel
    self.setButtonImage(homeRecommendViewModel.isFolded)
    self.tableView.reloadData()
    
    homeRecommendViewModel.foldChanged = { [weak self] isFolded in
      self?.setButtonImage(isFolded)
      self?.tableView.reloadData()
    }
  }
  
  func setButtonImage(_ isFolded: Bool) {
    let imageName = isFolded ? "unfold" : "fold"
    self.foldButton.setImage(
      UIImage(named: imageName),
      for: .normal
    )
  }
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
      self.homeRecommendViewModel?.itemCount ?? 0
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: HomeRecommendItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? HomeRecommendItemCell,
       let data = self.homeRecommendViewModel?.recommends?[indexPath.row] {
      cell.setData(data, rank: indexPath.row + 1)
    }
       
    return cell
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
  }
}
