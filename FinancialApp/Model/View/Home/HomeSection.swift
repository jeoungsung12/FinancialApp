//
//  HomeSection.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation

enum HomeSection: Hashable {
    case banner
    case info
    case category(title: String)
    case horizotional
    case vertical(title: String)
}

enum HomeItem: Hashable {
    case chart([CandleModel])
    case infoData(InfoDataModel)
    case newsList(NewsItems)
    case Ads(String)
    case orderBook([AddTradesModel])
}

struct InfoDataModel: Hashable {
    let title: String
    let subTitle: String
    let description: String
}
