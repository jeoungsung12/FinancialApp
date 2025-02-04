//
//  TradesModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation

struct TradesModel: Decodable {
    let market : String
    let trade_price : Double
    let trade_volume : Double
    let ask_bid : String
}
struct AddTradesModel: Decodable {
    let tradesData: TradesModel
    let coinName: String
    let englishName: String
}
