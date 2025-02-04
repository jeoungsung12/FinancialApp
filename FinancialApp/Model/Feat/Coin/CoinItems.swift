//
//  CoinItems.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import Foundation

enum CoinItems: CaseIterable {
    case chart
    case ads
    case news
}

struct CoinDetailModel {
    var chartData: [[CandleModel]]?
    var newsData: [NewsItems]?
    var ticksData: [[AddTradesModel]]?
    var greedIndex: GreedModel?
}

struct CoinDetailInput {
    var name: String?
    var type: CandleType
}
