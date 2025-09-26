//
//  Double+Extension.swift
//  KitsuTV
//
//  Created by 현유진 on 9/8/25.
//

import Foundation

extension Double {
  // MARK: - Time Formatting
  var durationFormatted: String {
    let totalSeconds = Int(self)
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60 % 60
    
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  // MARK: - Date Formatting
  var timestampFormatted: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yy.MM.dd"
    
    let date = Date(timeIntervalSince1970: self)
    return dateFormatter.string(from: date)
  }
}
