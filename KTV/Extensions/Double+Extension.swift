//
//  Double+Extension.swift
//  KTV
//
//  Created by 현유진 on 9/8/25.
//

import Foundation

extension Double {
  var timeFormatter: String {
    let totalSeconds = Int(self)
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60 % 60
    
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  var formattedTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yy.MM.dd"
    
    let date = Date(timeIntervalSince1970: self)
    return formatter.string(from: date)
  }
}
