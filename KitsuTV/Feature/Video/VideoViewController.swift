//
//  VideoViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import UIKit

enum PlayerState {
  case loading
  case readyToPlay
  case error
}

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
  // 실제로 사용하지 않을 때는 사라져있을 수 있기 때문에 weak로 선언하면 안된다.
  @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
  
  // MARK: - 제어 패널
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
    didSet {
      loadingIndicator.hidesWhenStopped = true
    }
  }
  @IBOutlet weak var loadingContainer: UIView!
  @IBOutlet weak var playButton: UIButton!
  
  private var contentSizeObservation: NSKeyValueObservation?
  private var videoViewModel: VideoViewModel = VideoViewModel()
  private var isControlPannelHidden: Bool = true {
    didSet {
      self.portraitControlPannel.isHidden = self.isControlPannelHidden
    }
  }
  private var playerState: PlayerState = .loading {
    didSet {
      self.upadteUI(for: playerState)
    }
  }
  
  func upadteUI(for status: PlayerState) {
    switch status {
    case .loading:
      loadingIndicator.startAnimating()
      loadingContainer.isHidden = false
      isControlPannelHidden = true
    case .readyToPlay:
      loadingIndicator.stopAnimating()
      loadingContainer.isHidden = true
      isControlPannelHidden = false
    case .error:
      loadingIndicator.startAnimating()
      loadingContainer.isHidden = false
      print("error")
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
    
    self.playerView.delegate = self
  }
  
  // 뷰의 화면 회전이나 크기가 곧 변경될 것이라는 것을 알려주는 메서드
  override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
  }
  
  private func isLandscape(size: CGSize) -> Bool {
    size.width > size.height
  }
  
  private func bindViewModel() {
    self.videoViewModel.dataChangeHandler = { [weak self] in
      self?.setupData($0)
    }
  }
  
  private func setupData(_ video: Video) {
    self.playerView.set(url: video.videoURL)
    self.playerView.play()
    
    self.titleLabel.text = video.title
    self.channelThumnailImageView.loadImage(url: video.channelImageUrl)
    self.channelNameLabel.text = video.channel
    self.updateDateLabel.text = video.uploadTimestamp.formattedTime
    self.playCountLabel.text = "\(video.playCount) views"
    self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
    self.recommendTableView.reloadData()
  }
  
  private func setupRecommendTableView() {
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
  
  private func updatePlayButton(isPlaying: Bool) {
    let playImage = isPlaying ? UIImage(named: "small_pause") : UIImage(named: "small_play")
    self.playButton.setImage(playImage, for: .normal)
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
  
  @IBAction func playDidTap(_ sender: UIButton) {
    if self.playerView.isPlaying {
      self.playerView.pause()
    } else {
      self.playerView.play()
    }
    
    self.updatePlayButton(isPlaying: self.playerView.isPlaying)
  }
  
  @IBAction func fastForwardDidTap(_ sender: UIButton) {
    self.playerView.forward()
  }
  
  @IBAction func rewindDidTap(_ sender: UIButton) {
    self.playerView.rewind()
  }
  
  @IBAction func closeDidTap(_ sender: UIButton) {
    self.dismiss(animated: true)
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

extension VideoViewController: PlayerViewDelegate {
  func playerViewLoading(_ playerView: PlayerView) {
    self.playerState = .loading
    print("Loading started")
  }
  
  func playerViewReadyToPlay(_ playerView: PlayerView) {
    self.playerState = .readyToPlay
    self.updatePlayButton(isPlaying: playerView.isPlaying)
    print("Ready to play")
  }
  
  func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
    
  }
  
  func playerViewDidFinishToPlay(_ playerView: PlayerView) {
    // 다시 재생 아이콘으로 바꾸고 클릭하면 처음부터 재생하는 로직으로 개선하고 싶다.
    self.playerView.seek(to: 0)
    self.updatePlayButton(isPlaying: false)
  }
  
}
