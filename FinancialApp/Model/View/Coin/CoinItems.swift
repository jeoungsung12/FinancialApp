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
    let chartData: [[CandleModel]]
    let newsData: [NewsItems]
    let ticksData: [[AddTradesModel]]
    let greedIndex: GreedModel?
}

struct CoinDetailInput {
    var name: String?
    var type: CandleType
}
