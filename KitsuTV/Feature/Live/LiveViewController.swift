//
//  LiveViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/27/25.
//

import UIKit

class LiveViewController: UIViewController {
  
  @IBOutlet weak var popularityButton: UIButton!
  @IBOutlet weak var startTimeButton: UIButton!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  private var liveViewModel: LiveViewModel = LiveViewModel()
  
  // MARK: - View Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupUI()
    self.setupCollectionView()
    self.bindViewModel()
    
    self.liveViewModel.request(sort: .popularity)
  }
  
  // MARK: - Setup
  private func setupUI() {
    self.containerView.layer.cornerRadius = 12
    self.containerView.layer.borderColor = UIColor(named: "border")?.cgColor
    self.containerView.layer.borderWidth = 1
  }
  
  private func setupCollectionView() {
    self.collectionView.register(
      UINib(nibName: LiveCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: LiveCell.identifier
    )
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  private func bindViewModel() {
    self.liveViewModel.dataChanged = { [weak self] in
      self?.collectionView.reloadData()
      // 스크롤 맨 위로
      self?.collectionView.setContentOffset(.zero, animated: true)
    }
  }
  
  // MARK: - Actions
  @IBAction func sortDidTap(_ sender: UIButton) {
    guard sender.isSelected == false else { return }
    
    self.popularityButton.isSelected = sender == self.popularityButton
    self.startTimeButton.isSelected = sender == self.startTimeButton
    
    if self.popularityButton.isSelected {
      self.liveViewModel.sortList(.popularity)
    } else {
      self.liveViewModel.sortList(.start)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LiveViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: LiveCell.height)
  }
}

// MARK: - UICollectionViewDataSource
extension LiveViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.liveViewModel.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: LiveCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? LiveCell,
       let data = self.liveViewModel.items?[indexPath.item] {
      cell.setData(data)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let videoViewController = VideoViewController()
    videoViewController.isLiveMode = true
    self.present(videoViewController, animated: true)
  }
}
