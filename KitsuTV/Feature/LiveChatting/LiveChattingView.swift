//
//  LiveChattingView.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import UIKit

protocol LiveChattingViewDelegate: AnyObject {
  func liveChattingViewCloseDidTap(_ chattingView: LiveChattingView)
}

class LiveChattingView: UIView {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var textField: UITextField!
  
  // MARK: - Properites
  private let liveChattingViewModel: LiveChattingViewModel = LiveChattingViewModel()
  weak var delegate: LiveChattingViewDelegate?
  
  override var isHidden: Bool {
    didSet {
      self.toggleViewModel()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setupCollectionView()
    self.setupTextField()
    self.toggleViewModel()
    self.bindViewModel()
  }
  
  // MARK: - Private Methods
  private func setupCollectionView() {
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.register(
      UINib(nibName: LiveChattingMessageCollectionViewCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier
    )
    self.collectionView.register(
      UINib(nibName: LiveChattingMyMessageCollectionViewCell.identifier, bundle: nil),
      forCellWithReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier
    )
  }
  
  private func setupTextField() {
    self.textField.delegate = self
    self.textField.attributedPlaceholder = NSAttributedString(
      string: "Join the chat!",
      attributes: [
        .foregroundColor: UIColor(named: "secondary") ?? .clear,
        .font: UIFont.systemFont(ofSize: 12, weight: .medium)
      ]
    )
  }
  
  private func toggleViewModel() {
    if self.isHidden {
      self.liveChattingViewModel.stop()
    } else {
      self.liveChattingViewModel.start()
    }
  }
  
  private func bindViewModel() {
    self.liveChattingViewModel.chattingReceived = { [weak self] in
      self?.collectionView.reloadData()
    }
  }
  
  // MARK: - Actions
  @IBAction func closeDidTap(_ sender: UIButton) {
    self.textField.resignFirstResponder()
    self.delegate?.liveChattingViewCloseDidTap(self)
  }
}

extension LiveChattingView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let item = self.liveChattingViewModel.messages[indexPath.item]
    let width = collectionView.frame.width - 32
    
    if item.isMine {
      return LiveChattingMyMessageCollectionViewCell.size(width: width, text: item.text)
    } else {
      return LiveChattingMessageCollectionViewCell.size(width: width, text: item.text)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
}

extension LiveChattingView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.liveChattingViewModel.messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = self.liveChattingViewModel.messages[indexPath.item]
    
    if item.isMine {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? LiveChattingMyMessageCollectionViewCell {
        cell.setText(item.text)
      }
      
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier,
        for: indexPath
      )
      
      if let cell = cell as? LiveChattingMessageCollectionViewCell {
        cell.setText(item.text)
      }
      
      return cell
    }
  }
}

extension LiveChattingView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text, !text.isEmpty else { return false }
    
    self.liveChattingViewModel.sendMessage(message: text)
    self.textField.text = nil
    
    return true
  }
}
