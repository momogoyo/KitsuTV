//
//  UIImageView+Task.swift
//  KTV
//
//  Created by 현유진 on 9/8/25.
//

import UIKit

// 1. URLSession.shared.data(): 서버에서 데이터 다운로드
  // 여기서 data는 튜플을 반환 -> 문서 참고
// 2. URLRequest.init(url: url)
// 3. .0: 튜플의 첫번째 값 - data만 가져오기
// 4. try? 에러나면 nil 반환
extension UIImageView {
  // Task: 비동기로 실행되는 작업 단위 - 백그라운드에서 작업
  func loadImage(url: URL) -> Task<Void, Never> {
    
    // 이미지 다운로드 및 설정
    let imageTask = Task.init {
      let request = URLRequest(url: url)
      guard let (data, _) = try? await URLSession.shared.data(for: request) else { return }
      guard let image = UIImage(data: data) else { return } // 이미지 변환
      
      self.image = image
    }
    
    return imageTask
  }
}
