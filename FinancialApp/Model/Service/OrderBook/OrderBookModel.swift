//
//  OrderBookModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation

struct OrderBookModel: Decodable {
    let market: String
    let total_ask_size: Double
    let total_bid_size: Double
    let orderbook_units: [Units]
}
struct Units: Decodable {
    let ask_price: Double
    let bid_price: Double
    let ask_size: Double
    let bid_size: Double
}
