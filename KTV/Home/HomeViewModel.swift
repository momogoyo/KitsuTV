//
//  HomeViewModel.swift
//  KTV
//
//  Created by 현유진 on 9/5/25.
//

import Foundation

// MVVM 패턴 - ViewModel로 관리
// 1. 데이터관리: JSON 데이터를 파싱해서 Home 객체로 변환
// 2. 비즈니스 로직 : 데이터 요청, 데이터 처리 로직
// 3. View와 Model 연결: ViewController가 직접 데이터를 처리하지 않고 ViewModel을 통해 처리

class HomeViewModel {
  private(set) var home: Home?
  // 데이터가 변경되면 실행할 함수 → Observer 패턴
  var dataChanged: (() -> Void)?
  
  func requestData() {
    // Bundle: 앱 빌드시 생성되는 앱의 리소스 폴더
    // 1. JSON 파일 경로 찾기
    guard let jsonURL = Bundle.main.url(forResource: "home", withExtension: "json") else {
      print("Resource not Found")
      return
    }
    
    let jsonDecoder = JSONDecoder()
    do {
      // 2. 경로에 있는 파일을 바이트 데이터로 읽어오기
      let data = try Data(contentsOf: jsonURL)
      // 3. JSON을 swift 객체(Home 구조체)로 변환
      let home = try jsonDecoder.decode(Home.self, from: data)
      self.home = home // 데이터 저장
      self.dataChanged?() // 데이터 바뀌었다고 노티!
    } catch {
      print("json parsing failed: \(error.localizedDescription)")
    }
  }
}
