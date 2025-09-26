//
//  NavigationViewController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/15/25.
//

import UIKit

/// 커스텀 네비게이션 컨트롤러: 최상위 뷰 컨트롤러가 상태바 스타일을 제어할 수 있도록 지원
class NavigationViewController: UINavigationController {
  
  // MARK: - Status Bar Configuration
  /// NavigationStack의 최상위 뷰 컨트롤러가 상태바 스타일을 조절할 수 있도록 설정
  /// - Returns: 현재 스택의 최상위 뷰 컨트롤러
  /// - Note: 이를 통해 각 화면마다 다른 상태바 스타일(라이트/다크)을 적용할 수 있음
  override var childForStatusBarStyle: UIViewController? {
    self.topViewController
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
