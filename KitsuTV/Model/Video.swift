//
//  Video.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import Foundation

struct Video: Decodable {
  let videoId: Int
  let videoURL: URL
  let title: String
  let uploadTimestamp: TimeInterval
  let playCount: Int
  let favoriteCount: Int
  let channelImageUrl: URL
  let channel: String
  let channelId: Int
  let recommends: [VideoListItem]
}
