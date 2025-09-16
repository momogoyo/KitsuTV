//
//  MyViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import UIKit

class MyViewController: UIViewController {
  
  @IBOutlet weak var profileView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var buttonGroups: UIView!
  @IBOutlet weak var bookmarkButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.profileView.layer.cornerRadius = 12
    self.profileView.layer.borderWidth = 1
    self.profileView.layer.borderColor = UIColor(named: "border")?.cgColor
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    self.profileImageView.clipsToBounds = true
    self.buttonGroups.layer.cornerRadius = 6
    self.buttonGroups.layer.borderWidth = 1
    self.buttonGroups.layer.borderColor = UIColor(named: "border")?.cgColor
  }
  
  @IBAction func bookmarkDidTap(_ sender: UIButton) {
    self.performSegue(withIdentifier: "bookmark", sender: nil)
  }
  
  @IBAction func favoriteDidTap(_ sender: UIButton) {
//    self.performSegue(withIdentifier: "favorite", sender: nil)
  }
}
