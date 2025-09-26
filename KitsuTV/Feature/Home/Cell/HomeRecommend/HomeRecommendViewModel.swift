//
//  HomeRecommendViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/9/25.
//

import Foundation

class HomeRecommendViewModel {
  
  // MARK: - Properties
  private(set) var isFolded: Bool = true {
    didSet {
      self.foldChanged?(self.isFolded)
    }
  }
  var foldChanged: ((Bool) -> Void)?
  var recommends: [VideoListItem]?
  
  // MARK: - Computed Properties
  var itemCount: Int {
    let count = self.isFolded ? 5 : self.recommends?.count ?? 0
    
    return min(self.recommends?.count ?? 0, count)
  }
  
  // MARK: - Methods
  func toggleFoldState() {
    self.isFolded.toggle()
  }
}
