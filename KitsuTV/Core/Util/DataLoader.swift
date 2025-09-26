//
//  DataLoader.swift
//  KitsuTV
//
//  Created by 현유진 on 9/8/25.
//

import Foundation

/// 네트워크를 통해 JSON 데이터를 가져와서 Swift 객체로 변환하는 유틸리티
struct DataLoader {
  
  // MARK: - Properties
  // 공유 URLSession 인스턴스 - 네트워크 요청에 사용
  private static let session: URLSession = .shared
  
  // MARK: - Public Methods
  /// URL에서 JSON 데이터를 가져와서 지정된 타입으로 디코딩
  /// - Parameters:
  ///   - url: 데이터를 가져올 URL 문자열
  ///   - type: 디코딩할 대상 타입
  /// - Returns: 디코딩된 객체
  /// - Throws: URL 검증 실패, 네트워크 오류, JSON 디코딩 오류
  static func load<T: Decodable>(
    url: String,
    for type: T.Type
  ) async throws -> T {
    let validatedURL = try self.validateURL(url)
    let responseData = try await self.fetchData(from: validatedURL)
    let decodedObject = try self.decodeJSON(responseData, to: type)
    
    return decodedObject
  }
  
  // MARK: - Private Methods
  /// URL 문자열의 유효성을 검증하고 URL 객체로 변환
  /// - Parameter urlString: 검증할 URL 문자열
  /// - Returns: 유효한 URL 객체
  /// - Throws: 유효하지 않은 URL인 경우 URLError
  private static func validateURL(_ urlString: String) throws -> URL {
    guard let url = URL(string: urlString) else {
      throw URLError(.unsupportedURL)
    }
    return url
  }
  
  /// URL에서 데이터를 비동기로 가져옴
  /// - Parameter url: 데이터를 요청할 URL
  /// - Returns: 서버로부터 받은 데이터
  /// - Throws: 네트워크 요청 실패 시 에러
  private static func fetchData(from url: URL) async throws -> Data {
    let urlRequest = URLRequest(url: url)
    let (data, _) = try await Self.session.data(for: urlRequest)
    
    return data
  }
  
  /// JSON 데이터를 지정된 Swift 타입으로 디코딩
  /// - Parameters:
  ///   - data: 디코딩할 JSON 데이터
  ///   - type: 변환할 대상 타입
  /// - Returns: 디코딩된 Swift 객체
  /// - Throws: JSON 디코딩 실패 시 에러
  private static func decodeJSON<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
    let jsonDecoder = JSONDecoder()
    
    return try jsonDecoder.decode(type, from: data)
  }
}
