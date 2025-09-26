//
//  HomeRecommendContainerCell.swift
//  KitsuTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

// MARK: - HomeRecommendContainerCellDelegate
protocol HomeRecommendContainerCellDelegate: AnyObject {
  func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
  func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UICollectionViewCell {
  
  static let identifier: String = "HomeRecommendContainerCell"
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var foldButton: UIButton!
  
  // MARK: - Properties
  private var homeRecommendViewModel: HomeRecommendViewModel?
  private var recommends: [VideoListItem]?
  weak var delegate: HomeRecommendContainerCellDelegate?
  
  // MARK: - Height Calculation
  static func height(homeRecommendViewModel: HomeRecommendViewModel) -> CGFloat {
    let top: CGFloat = 84 - 16 // cell의 상단 여백
    let bottom: CGFloat = 68 - 6 // cell의 하단 여백
    let footerInset: CGFloat = 51 // container -> footer 까지의 여백
    
    return VideoListItemCell.height * CGFloat(homeRecommendViewModel.itemCount) + top + bottom + footerInset
  }
  
  // MARK: - Setup
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupUI()
    self.setupTableView()
  }
  
  private func setupUI() {
    self.containerView.layer.cornerRadius = 12
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  private func setupTableView() {
    self.tableView.rowHeight = VideoListItemCell.height
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(
      UINib(nibName: VideoListItemCell.identifier, bundle: .main),
      forCellReuseIdentifier: VideoListItemCell.identifier
    )
  }
  
  // MARK: - Actions
  @IBAction func foldButtonDidTap(_ sender: UIButton) {
    self.homeRecommendViewModel?.toggleFoldState()
    self.delegate?.homeRecommendContainerCellFoldChanged(self)
  }
  
  // MARK: - Cell Configuration
  func setViewModel(_ homeRecommendViewModel: HomeRecommendViewModel) {
    self.homeRecommendViewModel = homeRecommendViewModel
    
    self.updateUI(isFolded: homeRecommendViewModel.isFolded)
    self.setupViewModelBinding(homeRecommendViewModel)
  }
  
  private func updateUI(isFolded: Bool) {
    self.setButtonImage(isFolded)
    self.tableView.reloadData()
  }
  
  private func setupViewModelBinding(_ homeRecommendViewModel: HomeRecommendViewModel) {
    homeRecommendViewModel.foldChanged = { [weak self] isFolded in
      self?.setButtonImage(isFolded)
      self?.tableView.reloadData()
    }
  }
  
  private func setButtonImage(_ isFolded: Bool) {
    let imageName = isFolded ? "unfold" : "fold"
    self.foldButton.setImage(
      UIImage(named: imageName),
      for: .normal
    )
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
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
      withIdentifier: VideoListItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? VideoListItemCell,
       let data = self.homeRecommendViewModel?.recommends?[indexPath.row] {
      cell.setData(data, rank: indexPath.row + 1)
    }
       
    return cell
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
  }
}
