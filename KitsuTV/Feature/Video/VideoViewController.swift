//
//  VideoViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/16/25.
//

import UIKit

class VideoViewController: UIViewController {
  
  // MARK: - 제어패널
  @IBOutlet weak var playButton: UIButton!
  
  // MARK: - Scroll
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var playCountLabel: UILabel!
  @IBOutlet weak var updateDateLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var channelThumnailImageView: UIImageView!
  @IBOutlet weak var channelNameLabel: UILabel!
  
  @IBOutlet weak var recommendTableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.channelThumnailImageView.layer.cornerRadius = self.channelThumnailImageView.frame.width / 2
  }
  
  @IBAction func commentDidTap(_ sender: UIButton) {
    
  }
}

extension VideoViewController {
  @IBAction func toggleControlPannel(_ sender: UITapGestureRecognizer) {
    
  }
  
  @IBAction func fastForwardDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func playDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func rewindDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func closeDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func moreDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func expandDidTap(_ sender: UIButton) {
    
  }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
  func setupRecommendTableView() {
    self.recommendTableView.delegate = self
    self.recommendTableView.dataSource = self
    self.recommendTableView.rowHeight = VideoListItemCell.height
    self.recommendTableView.register(
      UINib(nibName: VideoListItemCell.identifier, bundle: nil),
      forCellReuseIdentifier: VideoListItemCell.identifier
    )
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: VideoListItemCell.identifier,
      for: indexPath
    )
    
    return cell
  }
}
