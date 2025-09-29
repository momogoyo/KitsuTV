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
  private(set) var items: [Live.Item]?
  private(set) var sortOption: LiveSortOption = .popularity
  var dataChanged: (() -> Void)?
  
  func request(sort: LiveSortOption) {
    Task {
      do {
        let live = try await DataLoader.load(url: URLDefines.live, for: Live.self)
        
        if sort == .start {
          self.items = live.list.reversed()
        } else {
          self.items = live.list
        }
        
        self.dataChanged?()
      } catch {
        print("Live data load failed: \(error)")
      }
    }
  }
  
}
