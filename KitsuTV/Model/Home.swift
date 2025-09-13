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
  let recommends: [Recommend]
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
    let thumbnailImage: URL
    
    enum CodingKeys: String, CodingKey {
      case videoId
      case thumbnailImage = "imageUrl"
    }
  }
  
  struct Recent: Decodable {
    let timeStamp: Double
    let title: String
    let thumbnailImage: URL
    let videoId: Int
    let channel: String
    
    enum CodingKeys: String, CodingKey {
      case timeStamp
      case title
      case thumbnailImage = "imageUrl"
      case videoId
      case channel
    }
  }
  
  struct Recommend: Decodable {
    let playtime: Double
    let title: String
    let imageUrl: URL
    let videoId: Int
    let channel: String
  }
}
