//
//  LoginViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 8/30/25.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var loginButton: UIButton!
  
  // MARK: - View Configuration
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  // MARK: - Setup
  private func setupUI() {
    setupLoginButton()
  }
  
  private func setupLoginButton() {
    self.loginButton.layer.cornerRadius = 6
  }
  
  
  // MARK: - Actions
  @IBAction func loginDidTap(_ sender: UIButton) {
    self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
  }
}

