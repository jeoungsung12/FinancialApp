//
//  CoinResult.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/18.
//

import Foundation

struct CoinResult {
    let chartData: [CandleMinuteModel]
    let newsData: [NewsItems]
    let coinData: [[CoinDataWithAdditionalInfo]]
    let orderBook: [[AddTradesModel]]
}
