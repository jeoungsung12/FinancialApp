//
//  HomeSection.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation

enum HomeSection : Hashable {
    case banner(String)
    case category
    case horizotional
    case vertical
}
enum HomeItem : Hashable {
    case chart([CandleModel]) //TODO: - 변경
    case newsList(NewsItems)
    case Ads(String)
    case orderBook([AddTradesModel])
}
