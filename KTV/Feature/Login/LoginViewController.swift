//
//  LoginViewController.swift
//  KTV
//
//  Created by 현유진 on 8/30/25.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var loginButton: UIButton!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.loginButton.layer.cornerRadius = 8
    self.loginButton.layer.borderColor = UIColor(named: "bk-origin")?.cgColor
    self.loginButton.layer.borderWidth = 2
  }

  @IBAction func loginDidTap(_ sender: UIButton) {
    self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
  }
  
}

