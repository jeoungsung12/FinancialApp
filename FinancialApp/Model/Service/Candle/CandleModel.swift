//
//  CandleModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/04.
//

import Foundation


struct CandleMinuteModel: Decodable, Hashable {
    let market : String?
    let candle_date_time_utc : String?
    let candle_date_time_kst : String?
    let opening_price : Double?
    let high_price : Double?
    let low_price : Double?
    let trade_price : Double?
    let timestamp : Double?
    let candle_acc_trade_price : Double?
    let candle_acc_trade_volume : Double?
    let unit : Int?
}
struct CandleDayModel: Decodable, Hashable {
    let market : String?
    let candle_date_time_utc : String?
    let candle_date_time_kst : String?
    let opening_price : Double?
    let high_price : Double?
    let low_price : Double?
    let trade_price : Double?
    let timestamp : Double?
    let candle_acc_trade_price : Double?
    let candle_acc_trade_volume : Double?
    let prev_closing_price : Double?
    let change_price : Double?
    let change_rate : Double?
}
struct CandleWMModel: Decodable {
    let market : String?
    let candle_date_time_utc : String?
    let candle_date_time_kst : String?
    let opening_price : Double?
    let high_price : Double?
    let low_price : Double?
    let trade_price : Double?
    let timestamp : Double?
    let candle_acc_trade_price : Double?
    let candle_acc_trade_volume : Double?
    let first_day_of_period : String?
}
