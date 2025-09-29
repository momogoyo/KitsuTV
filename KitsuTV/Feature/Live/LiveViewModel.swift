//
//  LiveViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import Foundation

enum LiveSortOption {
  case popularity
  case start
}

@MainActor
class LiveViewModel {
  
  // MARK: - Properties
  private(set) var items: [Live.Item]?
  private(set) var sortOption: LiveSortOption = .popularity
  var dataChanged: (() -> Void)?
  
  // MARK: - Public Methods
  
  /// 현재 로드된 데이터에 새로운 정렬 옵션을 적용
  /// - Parameter sort: 적용할 정렬 옵션
  func sortList(_ sort: LiveSortOption) {
    guard self.items != nil else { return }
    
    self.sortOption = sort
    self.applySorting()
    self.dataChanged?()
  }
  
  /// 서버에서 라이브 데이터를 요청하고 정렬을 적용
  /// - Parameter sort: 적용할 정렬 옵션
  func request(sort: LiveSortOption) {
    self.sortOption = sort
    
    Task {
      do {
        let live = try await DataLoader.load(url: URLDefines.live, for: Live.self)
        self.items = live.list
        
        self.applySorting()
        self.dataChanged?()
      } catch {
        print("Live data load failed: \(error)")
      }
    }
  }
  
  // MARK: - Private Methods
  private func applySorting() {
    guard var currentItems = self.items else { return }
    
    switch sortOption {
    case .popularity:
      break
    case .start:
      currentItems.reverse()
      self.items = currentItems
    }
  }
}
