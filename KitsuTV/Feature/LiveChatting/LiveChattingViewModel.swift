//
//  LiveChattingViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import Foundation

@MainActor
class LiveChattingViewModel {
  
  private(set) var messages: [ChatMessage] = []
  private let liveChattingSimulator: LiveChattingSimulator = LiveChattingSimulator()
  var chattingReceived: (() -> Void)?
  
  init() {
    self.liveChattingSimulator.setMessageHandler { [weak self] in
      self?.messages.append($0)
      self?.chattingReceived?()
    }
  }
  
  func start() {
    self.liveChattingSimulator.start()
  }
  
  func stop() {
    self.liveChattingSimulator.stop()
  }
  
  func sendMessage(message: String) {
    self.liveChattingSimulator.sendMessage(message)
  }
}
