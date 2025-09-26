//
//  BookmarkViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import Foundation

@MainActor class BookmarkViewModel {
  
  // MARK: - Properties
  /// 북마크된 채널 목록 데이터
  private(set) var channels: [Bookmark.Item]?
  
  /// 데이터 변경 시 실행될 콜백 클로저 (Observer 패턴)
  /// UI 업데이트를 위해 ViewController에서 설정
  var dataChanged: (() -> Void)?
  
  // MARK: - Public Methods
  /// 서버에서 북마크 데이터를 요청하고 UI에 반영
  /// - 네트워크 요청을 통해 북마크 목록을 가져옴
  /// - 성공 시 dataChanged 콜백을 호출하여 UI 업데이트 트리거
  /// - 실패 시 에러 로그 출력
  func request() {
    Task {
      do {
        // 백그라운드에서 네트워크 요청 수행
        let bookmarkData = try await DataLoader.load(url: URLDefines.bookmark, for: Bookmark.self)
        // 데이터 업데이트
        self.updateChannels(bookmarkData.channels)
        // UI 업데이트 알림 (@MainActor로 메인 스레드에서 실행됨)
        self.notifyDataChanged()
      } catch {
        self.handleRequestError(error)
      }
    }
  }
  
  // MARK: - Private Methods
  /// 채널 데이터 업데이트
  /// - Parameter channels: 새로운 채널 목록
  private func updateChannels(_ channels: [Bookmark.Item]) {
    self.channels = channels
  }
  
  /// 데이터 변경 완료를 알리는 콜백 실행
  private func notifyDataChanged() {
    self.dataChanged?()
  }
  
  /// 네트워크 요청 실패 시 에러 처리
  /// - Parameter error: 발생한 에러
  private func handleRequestError(_ error: Error) {
    print("Bookmark list load failed: \(error.localizedDescription)")
    
    // TODO: 사용자에게 에러 알림 표시 또는 재시도 로직 추가
  }
}
