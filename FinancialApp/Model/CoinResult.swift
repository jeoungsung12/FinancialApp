//
//  CoinResult.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/18.
//

import Foundation

struct CoinResult {
    let greedData: GreedModel
    let loanData: [LoanModel]
    let international: [InternationalModel]
    let exchange: [FinancialModel]
    let chartData: [CandleModel]
    let newsData: [NewsItems]
    let orderBook: [[AddTradesModel]]
}
