//
//  TabBarController.swift
//  KitsuTV
//
//  Created by 현유진 on 9/2/25.
//

import UIKit

/// 커스텀 탭바 컨트롤러: 세로 방향으로만 화면 회전을 제한
class TabBarController: UITabBarController {
  // MARK: - Orientation Configuration
  
  /// 지원하는 화면 방향을 세로 방향으로만 제한
  /// - Returns: 세로 방향(.portrait)만 허용하는 마스크
  /// - Note: 앱 전체가 세로 방향으로 고정되어 일관된 사용자 경험 제공
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
