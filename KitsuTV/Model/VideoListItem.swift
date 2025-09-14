//
//  VideoListItem.swift
//  KitsuTV
//
//  Created by 현유진 on 9/14/25.
//

import Foundation

struct VideoListItem: Decodable {
  let playtime: Double
  let title: String
  let imageUrl: URL
  let videoId: Int
  let channel: String
}
