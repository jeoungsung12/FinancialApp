//
//  TradesModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
struct TradesModel : Hashable, Codable {
    let market : String?
    let trade_date_utc : String?
    let trade_time_utc : String?
    let timestamp : Double?
    let trade_price : Double?
    let trade_volume : Double?
    let prev_closing_price : Double?
    let change_price : Double?
    let ask_bid : String?
    let sequential_id : Double?
}
struct AddTradesModel : Hashable, Codable {
    let tradesData: TradesModel
    let coinName: String
    let englishName: String
}
