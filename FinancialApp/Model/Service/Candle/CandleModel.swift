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


enum CandleType: String, CaseIterable {
    case days = "days?market="
    case weeks = "weeks?market="
    case months = "months?market="
    case years = "years?market="
    
    var title: String {
        switch self {
        case .days:
            "일"
        case .weeks:
            "주"
        case .months:
            "월"
        case .years:
            "년"
        }
    }
    
    func returnType(_ title: String) -> CandleType {
        if let type = CandleType.allCases.filter({$0.title == title}).first {
            return type
        }
        return .days
    }
}
