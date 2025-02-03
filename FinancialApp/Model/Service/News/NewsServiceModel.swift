//
//  NewsServiceModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
struct NewsServiceModel: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [NewsItems]
}

struct NewsItems: Decodable {
    let title: String
    let originallink: String
    let link: String
    let description: String
    let pubDate: String
}
