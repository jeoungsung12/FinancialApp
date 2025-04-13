//
//  WebSocketCandleData.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import Foundation

struct WebSocketCandleData: Decodable {
    let type: String
    let code: String
    let timestamp: Int64
    let trade_date: String
    let trade_time: String
    let trade_timestamp: Int64
    let trade_price: Double
    let trade_volume: Double
    let ask_bid: String
    let prev_closing_price: Double
    let change: String
    let change_price: Double
    let sequential_id: Int64
    let best_ask_price: Double
    let best_ask_size: Double
    let best_bid_price: Double
    let best_bid_size: Double
    let stream_type: String
}
