//
//  NavigationViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/15/25.
//

import UIKit

class NavigationViewController: UINavigationController {
  
  // NavigationStack에 해당하는 최상위 뷰 컨트롤러가 상태바 스타일을 조절할 수 있도록 해주는 override
  override var childForStatusBarStyle: UIViewController? {
    self.topViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
