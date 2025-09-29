//
//  Live.swift
//  KitsuTV
//
//  Created by 현유진 on 9/29/25.
//

import Foundation

struct Live: Decodable {
  let list: [Item]
}

extension Live {
  struct Item: Decodable {
    let title: String
    let channel: String
    let videoId: Int
    let thumbnailUrl: URL
  }
}
