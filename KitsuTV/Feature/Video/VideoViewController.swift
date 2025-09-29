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
  
  // Video Detail Section
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var updateDateLabel: UILabel!
  @IBOutlet weak var playCountLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  // Channel Info Section
  @IBOutlet weak var channelThumbnailImageView: UIImageView!
  @IBOutlet weak var channelNameLabel: UILabel!
  
  // Recommend Section
  @IBOutlet weak var recommendTableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  
  // Player Section
  @IBOutlet weak var playerView: PlayerView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var seekbarView: SeekbarView!
  @IBOutlet weak var landscapeTitleLabel: UILabel!
  @IBOutlet weak var landscapePlayButton: UIButton!
  @IBOutlet weak var landscapePlayTimeLabel: UILabel!
  @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
  
  // Control Panel
  @IBOutlet weak var portraitControlPanel: UIView!
  @IBOutlet weak var landscapeControlPanel: UIView!
  @IBOutlet weak var loadingContainer: UIView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
    didSet {
      loadingIndicator.hidesWhenStopped = true
    }
  }
  
  // Live Chatting
  @IBOutlet weak var liveChattingView: LiveChattingView!
  
  // MARK: - Properties
  private var videoViewModel: VideoViewModel = VideoViewModel()
  private var contentSizeObservation: NSKeyValueObservation?
  
  // MARK: - Property Observer
  private var isControlPanelHidden: Bool = true {
    didSet {
      if self.isLandscape(size: self.view.frame.size) {
        self.landscapeControlPanel.isHidden = self.isControlPanelHidden
      } else {
        self.portraitControlPanel.isHidden = self.isControlPanelHidden
      }
    }
  }
  private var playerState: PlayerState = .loading {
    didSet {
      self.upadteUI(for: playerState)
    }
  }
  
  // MARK: - Initialization
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    self.modalPresentationStyle = .fullScreen
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.modalPresentationStyle = .fullScreen
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.channelThumbnailImageView.layer.cornerRadius = self.channelThumbnailImageView.frame.width / 2
    self.setupRecommendTableView()
    
    self.bindViewModel()
    self.videoViewModel.request()
    
    self.playerView.delegate = self
    self.seekbarView.delegate = self
    
    self.liveChattingView.delegate = self
    self.liveChattingView.isHidden = false
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    self.switchControlPannel(size: size)
    self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
  }
  
  // MARK: - Setup Methods
  private func bindViewModel() {
    self.videoViewModel.dataChangeHandler = { [weak self] in
      self?.setupData($0)
    }
  }
  
  private func setupData(_ video: Video) {
    self.playerView.set(url: video.videoURL)
    self.playerView.play()
    
    self.titleLabel.text = video.title
    self.landscapeTitleLabel.text = video.title
    self.channelThumbnailImageView.loadImage(url: video.channelImageUrl)
    self.channelNameLabel.text = video.channel
    self.updateDateLabel.text = video.uploadTimestamp.timestampFormatted
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
  
  // MARK: - Update UI Methods
  private func upadteUI(for status: PlayerState) {
    switch status {
    case .loading:
      loadingIndicator.startAnimating()
      loadingContainer.isHidden = false
      isControlPanelHidden = true
    case .readyToPlay:
      loadingIndicator.stopAnimating()
      loadingContainer.isHidden = true
      isControlPanelHidden = false
    case .error:
      loadingIndicator.startAnimating()
      loadingContainer.isHidden = false
    }
  }
  
  private func updatePlayButton(isPlaying: Bool) {
    let playImage = isPlaying ? UIImage(named: "small_pause") : UIImage(named: "small_play")
    let landscapePlayImage = isPlaying ? UIImage(named: "big_pause") : UIImage(named: "big_play")
    self.playButton.setImage(playImage, for: .normal)
    self.landscapePlayButton.setImage(landscapePlayImage, for: .normal)
  }
  
  private func rotateScene(landscape: Bool) {
    if #available(iOS 16.0, *) {
      self.view.window?.windowScene?.requestGeometryUpdate(
        .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
      )
    } else {
      let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
      UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
      UIViewController.attemptRotationToDeviceOrientation()
    }
  }
  
  // MARK: - Helper Methods
  private func isLandscape(size: CGSize) -> Bool {
    size.width > size.height
  }
  
  private func switchControlPannel(size: CGSize) {
    guard self.isControlPanelHidden == false else { return }
    
    self.landscapeControlPanel.isHidden = !self.isLandscape(size: size)
    self.portraitControlPanel.isHidden = self.isLandscape(size: size)
  }
  
  // MARK: - Actions
  @IBAction func toggleControlPannel(_ sender: UITapGestureRecognizer) {
    self.isControlPanelHidden.toggle()
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
  
  @IBAction func moreDidTap(_ sender: UIButton) {
    let moreViewController: MoreViewController = MoreViewController()
    self.present(moreViewController, animated: false)
  }
  
  @IBAction func expandDidTap(_ sender: UIButton) {
    self.rotateScene(landscape: true)
  }
  
  @IBAction func shrinkDidTap(_ sender: UIButton) {
    self.rotateScene(landscape: false)
  }
  
  @IBAction func commentDidTap(_ sender: UIButton) {
    // TODO: Implement expand functionality
  }
}

// MARK: - PlayerViewDelegate
extension VideoViewController: PlayerViewDelegate {
  func playerViewLoading(_ playerView: PlayerView) {
    self.playerState = .loading
  }
  
  func playerViewReadyToPlay(_ playerView: PlayerView) {
    self.seekbarView.setTotalPlayTime(self.playerView.totalPlayTime)
    self.playerState = .readyToPlay
    self.updatePlayButton(isPlaying: playerView.isPlaying)
    self.updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
  }
  
  func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
    self.seekbarView.setPlayTime(playTime, playableTime: playableTime)
    self.updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
  }
  
  func playerViewDidFinishToPlay(_ playerView: PlayerView) {
    self.playerView.seek(to: 0)
    self.updatePlayButton(isPlaying: false)
  }
  
  private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
    let playTimeText = playTime.durationFormatted
    let totalPlayTimeText = totalPlayTime.durationFormatted
    
    self.landscapePlayTimeLabel.text = playTimeText + " / " + totalPlayTimeText
  }
}

// MARK: - SeekbarViewDelegate
extension VideoViewController: SeekBarViewDelegate {
  func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double) {
    self.playerView.seek(to: percent)
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
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

// MARK: - LiveChattingViewDelegate
extension VideoViewController: LiveChattingViewDelegate {
  func liveChattingViewCloseDidTap(_ chattingView: LiveChattingView) {
    self.liveChattingView.isHidden = true
  }
}
