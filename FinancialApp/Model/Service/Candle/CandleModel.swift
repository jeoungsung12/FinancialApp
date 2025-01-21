//
//  CandleModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/04.
//

import Foundation

struct CandleModel: Decodable, Hashable {
    let market: String
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
}
