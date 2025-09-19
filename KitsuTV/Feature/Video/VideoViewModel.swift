//
//  VideoViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import Foundation

@MainActor class VideoViewModel {
  private(set) var video: Video?
  var dataChangeHandler: ((Video) -> Void)?
  
  func request() {
    Task {
      do {
        let video = try await DataLoader.load(url: URLDefines.video, for: Video.self)
        print(video)
        self.video = video
        self.dataChangeHandler?(video)
      } catch {
        print("Video load did failed \(error.localizedDescription)")
      }
    }
  }
}
