//
//  Home.swift
//  KTV
//
//  Created by 현유진 on 9/5/25.
//

import Foundation

struct Home: Decodable {
  let videos: [Video]
  let rankings: [Ranking]
  let recents: [Recent]
  let recommends: [Recommand]
}

extension Home {
  struct Video: Decodable {
    let channel: String
    let subtitle: String
    let isHot: Bool
    let title: String
    let channelThumbnailURL: URL
    let imageUrl: URL
    let videoId: Int
    let channelDescription: String
  }
  
  struct Ranking: Decodable {
    let videoId: Int
    let imageUrl: URL
  }
  
  struct Recent: Decodable {
    let timeStamp: Double
    let title: String
    let imageUrl: URL
    let videoId: Int
    let channel: String
  }
  
  struct Recommand: Decodable {
    let playtime: Int
    let title: String
    let imageUrl: URL
    let videoId: Int
    let channel: String
  }
}
