//
//  GetAllCoinModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation

struct GetAllCoinModel: Decodable {
    let market: String
    let korean_name: String
    let english_name: String
//    let market_event: MarketEvent
}

struct MarketEvent: Decodable {
    let warning: Bool
    let caution: MarkeCaution
    
    struct MarkeCaution: Decodable {
        
    }
}

//TODO: - 변경
struct CoinData: Hashable, Decodable {
    let market: String
    let trade_date: String
    let trade_time: String
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
    let prev_closing_price: Double
    let change: String
    let change_price: Double
    let change_rate: Double
    let trade_volume: Double
    let acc_trade_price: Double
    let acc_trade_price_24h: Double
    let acc_trade_volume: Double
    let acc_trade_volume_24h: Double
    let highest_52_week_price: Double
    let highest_52_week_date: String
    let lowest_52_week_price: Double
    let lowest_52_week_date: String
}

struct CoinDataWithAdditionalInfo {
    let coinData: CoinData
    let coinName: String
}
