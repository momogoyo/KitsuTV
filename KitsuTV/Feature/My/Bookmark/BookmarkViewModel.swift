//
//  BookmarkViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import Foundation

@MainActor class BookmarkViewModel {
  private(set) var channels: [Bookmark.Item]?
  var dataChanged: (() -> Void)?
  
  func request() {
    Task {
      do {
        let data = try await DataLoader.load(url: URLDefines.bookmark, for: Bookmark.self)
        self.channels = data.channels
        self.dataChanged?()
      } catch {
        print("Bookmark list load failed: \(error.localizedDescription)")
      }
    }
  }
  
}
