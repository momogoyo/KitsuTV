//
//  MoreViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import UIKit

class MoreViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  
  private let moreViewModel: MoreViewModel = MoreViewModel()
  
  // MARK: - Initialization
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.modalPresentationStyle = .overFullScreen
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTableView()
  }
  
  override func viewWillLayoutSubviews() {
    self.setupCornerRadius()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate { _ in
      self.setupCornerRadius()
    }
  }
  
  // MARK: - Setup
  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.rowHeight = MoreTableViewCell.height
    self.tableView.register(
      UINib(nibName: MoreTableViewCell.identifier, bundle: nil),
      forCellReuseIdentifier: MoreTableViewCell.identifier
    )
  }
  
  private func setupCornerRadius() {
    let path = UIBezierPath(
      roundedRect: self.headerView.bounds,
      byRoundingCorners: [.topLeft, .topRight],
      cornerRadii: (CGSize(width: 13, height: 13))
    )
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    self.headerView.layer.mask = maskLayer
    
    // self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    // self.headerView.layer.cornerRadius = 13
  }
  
  // MARK: - Actions
  @IBAction func closeDidTap(_ sender: UIButton) {
    self.dismiss(animated: false)
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.moreViewModel.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: MoreTableViewCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? MoreTableViewCell {
      cell.setItem(
        self.moreViewModel.items[indexPath.row],
        separatorHidden: indexPath.row + 1 == self.moreViewModel.items.count
      )
    }
    
    return cell
  }
}
