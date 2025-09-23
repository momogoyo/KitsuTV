//
//  VideoViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import UIKit

class VideoViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var updateDateLabel: UILabel!
  @IBOutlet weak var playCountLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var channelThumnailImageView: UIImageView!
  @IBOutlet weak var channelNameLabel: UILabel!
  
  @IBOutlet weak var recommendTableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var portraitControlPannel: UIView!
  @IBOutlet weak var playerView: PlayerView!
  
  private var contentSizeObservation: NSKeyValueObservation?
  private var videoViewModel: VideoViewModel = VideoViewModel()
  private var isControlPannelHidden: Bool = true {
    didSet {
      self.portraitControlPannel.isHidden = self.isControlPannelHidden
    }
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.modalPresentationStyle = .fullScreen
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.modalPresentationStyle = .fullScreen
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.channelThumnailImageView.layer.cornerRadius = self.channelThumnailImageView.frame.width / 2
    
    self.setupRecommendTableView()
    self.bindViewModel()
    self.videoViewModel.request()
  }
  
  private func bindViewModel() {
    self.videoViewModel.dataChangeHandler = { [weak self] in
      self?.setupData($0)
    }
  }
  
  private func setupData(_ video: Video) {
    self.titleLabel.text = video.title
    self.channelThumnailImageView.loadImage(url: video.channelImageUrl)
    self.channelNameLabel.text = video.channel
    self.updateDateLabel.text = video.uploadTimestamp.formattedTime
    self.playCountLabel.text = "\(video.playCount) views"
    self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
    self.recommendTableView.reloadData()
  }
  
  func setupRecommendTableView() {
    self.recommendTableView.delegate = self
    self.recommendTableView.dataSource = self
    self.recommendTableView.rowHeight = VideoListItemCell.height
    self.recommendTableView.register(
      UINib(nibName: VideoListItemCell.identifier, bundle: nil),
      forCellReuseIdentifier: VideoListItemCell.identifier
    )
    
    self.contentSizeObservation = self.recommendTableView.observe(
      \.contentSize,
       changeHandler: { [weak self] tableView, _ in
         self?.tableViewHeightConstraint.constant = tableView.contentSize.height
       }
    )
  }
  
  @IBAction func moreDidTap(_ sender: UIButton) {
    let moreViewController: MoreViewController = MoreViewController()
    self.present(moreViewController, animated: false)
  }
  
  @IBAction func commentDidTap(_ sender: UIButton) {
    
  }
  
  @IBAction func toggleControlPannel(_ sender: UITapGestureRecognizer) {
    self.isControlPannelHidden.toggle()
  }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.videoViewModel.video?.recommends.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: VideoListItemCell.identifier,
      for: indexPath
    )
    
    if let cell = cell as? VideoListItemCell,
       let data = self.videoViewModel.video?.recommends[indexPath.row] {
      cell.setData(data, rank: indexPath.row + 1)
    }
    
    return cell
  }
}
