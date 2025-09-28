//
//  MyViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class MyViewController: UIViewController {
  
  // Profile Section
  @IBOutlet weak var profileView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  // Button Section
  @IBOutlet weak var buttonGroups: UIView!
  @IBOutlet weak var bookmarkButton: UIButton!
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupProfileSection()
    self.setupButtonSection()
  }
  
  private func setupProfileSection() {
    self.setupProfileView()
    self.setupProfileImageView()
  }
  
  private func setupProfileView() {
    self.profileView.layer.cornerRadius = 12
    self.profileView.layer.borderWidth = 1
    self.profileView.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  private func setupProfileImageView() {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    self.profileImageView.clipsToBounds = true
  }
  
  private func setupButtonSection() {
    self.buttonGroups.layer.cornerRadius = 6
    self.buttonGroups.layer.borderWidth = 1
    self.buttonGroups.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  // MARK: - Actions
  @IBAction func bookmarkDidTap(_ sender: UIButton) {
    self.navigateToBookmark()
  }
  
  @IBAction func favoriteDidTap(_ sender: UIButton) {
    self.navigateToFavorite()
  }
  
  // MARK: - Navigation
  private func navigateToBookmark() {
    self.performSegue(withIdentifier: "bookmark", sender: nil)
  }
  
  private func navigateToFavorite() {
    self.performSegue(withIdentifier: "favorite", sender: nil)
  }
}
