//
//  PlayerView.swift
//  KitsuTV
//
//  Created by 현유진 on 9/22/25.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
  // CALayer 대신 다른 Layer를 쓸 수 있게 해주는 클래스 프로퍼티
  override class var layerClass: AnyClass {
    // 뷰가 생성될 때 AVPlayerLayer 인스턴스가 만들어짐
    AVPlayerLayer.self
  }
  
  // 편리한 접근 프로퍼티
  var avPlayerLayer: AVPlayerLayer? {
    // 깨진 유리창처럼 이렇게 확실한 경우에도 !를 쓰면 나도 모르게 크래시가 날 수 있기 때문에 가능하면 지양한다.
    self.layer as? AVPlayerLayer
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
