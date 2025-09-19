//
//  MoreViewModel.swift
//  KitsuTV
//
//  Created by 현유진 on 9/19/25.
//

import Foundation

struct MoreViewModel {
  let items: [MoreItem] = [
    .init(title: "Quality", rightText: "Auto/720"),
    .init(title: "Autoplay", rightText: "ON"),
    .init(title: "Share", rightText: nil),
    .init(title: "Report", rightText: nil)
  ]
}

struct MoreItem {
  let title: String
  let rightText: String?
}
