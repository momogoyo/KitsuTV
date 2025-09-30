//
//  LiveChattingSimulator.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import Foundation

struct ChatMessage {
  let isMine: Bool
  let text: String
}

@MainActor class LiveChattingSimulator {
  
  typealias MessageHandler = ((ChatMessage) -> Void)
  
  // MARK: - Properties
  private var callback: MessageHandler?
  private var task: Task<Void, Never>?
  
  // MARK: - Initialize
  deinit {
    self.task?.cancel()
  }
  
  func start() {
    self.task = .init(operation: { [weak self] in
      guard let self else {
        return
      }
      
      while true {
        do {
          try Task.checkCancellation()
          
          let randomSeconds = UInt64.random(in: 10...20)
          try await Task.sleep(nanoseconds: 1_000_000_000 / 10 * randomSeconds)
          let message = self.randomMessage
          self.callback?(.init(isMine: false, text: message))
        } catch {
          break
        }
      }
    })
  }
  
  func stop() {
    self.task?.cancel()
    self.task = nil
  }
  
  func sendMessage(_ message: String) {
    self.callback?(.init(isMine: true, text: message))
  }
  
  func setMessageHandler(_ handler: MessageHandler?) {
    self.callback = handler
  }
  
  private var randomMessage: String {
    let messages = [
      "First! 🔥",
      "Let's gooo!",
      "This is fire 🔥🔥🔥",
      "W stream",
      "POV: you're early",
      "Who else is watching in 2025?",
      "The vibes are immaculate",
      "This hits different",
      "I'm literally crying rn",
      "No way this is happening",
      "Chat is this real?",
      "Bro what 💀",
      "💀💀💀",
      "I can't even",
      "This is actually insane",
      "Peak content right here",
      "Why is nobody talking about this??",
      "Underrated tbh",
      "This deserves more views",
      "Algorithm brought me here",
      "Thanks for the recommendation YouTube",
      "Came for the thumbnail, stayed for the content",
      "My respect: 📈📈📈",
      "Character development goes crazy",
      "The plot twist though",
      "I did NOT see that coming",
      "Bro cooked with this one 👨‍🍳",
      "He's speaking facts",
      "Say it louder for the people in the back!",
      "Pin this comment",
      "Yo can I get pinned?",
      "Edit: thanks for the likes!",
      "Update: still watching in 2025",
      "POV: you keep refreshing for new comments",
      "Bro really said 💀",
      "The way I gasped",
      "My jaw is on the floor",
      "This changed my life perspective",
      "I'll never look at this the same way",
      "Respect +++",
      "Mad respect honestly",
      "Legend behavior",
      "Main character energy",
      "That's so valid",
      "Real ones know",
      "IYKYK",
      "If you know, you know 👀",
      "The nostalgia is hitting hard",
      "Takes me back fr",
      "Simpler times man...",
      "Why am I crying in the club rn",
    ]
    
    return messages[Int.random(in: 0..<messages.count)]
  }
}
