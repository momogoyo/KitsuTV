//
//  DataLoader.swift
//  KTV
//
//  Created by 현유진 on 9/8/25.
//

import Foundation

struct DataLoader {
  private static let session: URLSession = .shared
  
  static func load<T: Decodable>(url: String, for type: T.Type) async throws -> T {
    // URL 검증
    guard let url = URL(string: url) else {
      throw URLError(.unsupportedURL)
    }
    
    // 네트워크 요청 - 비동기 데이터 다운로드
    // static 메서드 안에서는 Self를 명시적으로 써서 DateLoader라는 것을 가리키는게 좋다.
    let data = try await Self.session.data(for: .init(url: url)).0
    // JSON을 Swift 객체로 변환
    let jsonDecorder = JSONDecoder()
    
    return try jsonDecorder.decode(T.self, from: data)
  }
}
