//
//  Bookmark.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import Foundation

struct Bookmark: Decodable {
  let channels: [Item]
  
  struct Item: Decodable {
    let channel: String
    let channelId: Int
    let thumbnail: URL
  }
}
