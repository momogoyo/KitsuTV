//
//  FavoriteViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import Foundation

@MainActor class FavoriteViewModel {
  private(set) var favorite: Favorite?
  var dataChanged: (() -> Void)?
  
  func request() {
    Task {
      do {
        let favorite = try await DataLoader.load(url: URLDefines.favorite, for: Favorite.self)
        self.favorite = favorite
        self.dataChanged?()
      } catch {
        print("Favorite list load failed: \(error.localizedDescription)")
      }
    }
  }
}
