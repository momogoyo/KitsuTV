//
//  HomeViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/5/25.
//

import Foundation

@MainActor class HomeViewModel {
  
  // MARK: - Properties
  /// 홈 화면 데이터 모델
  private(set) var home: Home?
  /// 추천 영상 관련 로직을 담당하는 하위 ViewModel
  var recommendViewModel: HomeRecommendViewModel = HomeRecommendViewModel()
  
  /// 데이터 변경 시 실행될 콜백 클로저 (Observer 패턴)
  /// UI 업데이트를 위해 ViewController에서 설정
  var dataChanged: (() -> Void)?
  
  // MARK: - Public Methods
  /// 홈 화면 데이터를 서버에서 가져와서 UI에 반영
  /// - 네트워크 요청을 통해 JSON 데이터를 받아옴
  /// - 성공 시 dataChanged 콜백을 호출하여 UI 업데이트 트리거
  /// - 실패 시 에러 로그 출력
  func requestData() {
    Task {
      do {
        // 백그라운드에서 네트워크 요청 수행
        let homeData = try await DataLoader.load(url: URLDefines.home, for: Home.self)
        // 데이터 업데이트
        self.updateHomeData(homeData)
        // UI 업데이트 알림 (@MainActor로 메인 스레드에서 실행됨)
        self.notifyDataChanged()
      } catch {
        self.handleDataLoadError(error)
      }
    }
  }
  
  // MARK: - Private Methods
  /// 홈 데이터와 추천 데이터를 업데이트
  /// - Parameter homeData: 서버에서 받아온 홈 데이터
  private func updateHomeData(_ homeData: Home) {
    self.home = homeData
    self.recommendViewModel.recommends = homeData.recommends
  }
  
  /// 데이터 변경 완료를 알리는 콜백
  private func notifyDataChanged() {
    self.dataChanged?()
  }
  
  /// 데이터 로딩 실패 시 에러 처리
  /// - Parameter error: 발생한 에러
  private func handleDataLoadError(_ error: Error) {
    print("JSON Parsing Failed: \(error.localizedDescription)")
    
    // TODO: - 사용자에게 에러 알림 표시 또는 재시도 로직 추가
  }
  
  //  func requestData() {
  //    // Bundle: 앱 빌드시 생성되는 앱의 리소스 폴더
  //    // 1. JSON 파일 경로 찾기
  //    guard let jsonURL = Bundle.main.url(forResource: "home", withExtension: "json") else {
  //      return
  //    }
  //
  //    let jsonDecoder = JSONDecoder()
  //    do {
  //      // 2. 경로에 있는 파일을 바이트 데이터로 읽어오기
  //      let data = try Data(contentsOf: jsonURL)
  //      // 3. JSON을 swift 객체(Home 구조체)로 변환
  //      let home = try jsonDecoder.decode(Home.self, from: data)
  //      self.home = home // 데이터 저장
  //      self.dataChanged?() // 데이터 바뀌었다고 노티
  //    } catch {
  //      print("json parsing failed: \(error.localizedDescription)")
  //    }
  //  }
}
