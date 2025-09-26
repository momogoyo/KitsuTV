//
//  UIImageView+Task.swift
//  KitsuTV
//
//  Created by 현유진 on 9/8/25.
//

import UIKit

/// UIImageView에 비동기 이미지 로딩 기능 추가
extension UIImageView {
  
  /// URL에서 이미지를 비동기로 다운로드하여 ImageView에 설정
  /// - Parameter url: 다운로드할 이미지의 URL
  /// - Returns: 취소 가능한 Task 객체 (셀 재사용 시 이미지 로딩 취소에 활용)
  /// - Note: @discardableResult로 반환값을 사용하지 않아도 경고가 발생하지 않음
  @discardableResult
  func loadImage(url: URL) -> Task<Void, Never> {
    return self.createImageLoadingTask(for: url)
  }
  
  /// 실제 이미지 다운로드 작업을 수행하는 Task 생성
  /// - Parameter url: 다운로드 할 이미지 URL
  /// - Returns: 이미지 다운로드 Task
  private func createImageLoadingTask(for url: URL) -> Task<Void, Never> {
    let imageTask = Task.init {
      await self.downloadAndSetImage(from: url)
    }
    
    return imageTask
  }
  
  /// URL에서 이미지를 다운로드하고 UI에 설정
  /// - Parameter url: 이미지 다운로드 URL
  private func downloadAndSetImage(from url: URL) async {
    // 네트워크 요청 생성
    let request = URLRequest(url: url)
    
    // 이미지 데이터 다운로드
    // URLSession.shared.data()는 (Data, URLResponse) 튜플을 반환
    guard let (data, _) = try? await URLSession.shared.data(for: request) else { return }
    // 이미지 데이터를 UIImage로 변환
    guard let downloadedImage = UIImage(data: data) else { return }
    
    // 메인 스레드에서 UI 업데이트
    await MainActor.run {
      self.image = downloadedImage
    }
  }
}

