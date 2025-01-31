//
//  GreedModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/21/25.
//

import Foundation

struct GreedModel: Decodable, Hashable {
    let data: [GreedData]
}

struct GreedData: Decodable, Hashable {
    let value: String
    let value_classification: String
}

enum KoreanGreed: String, CaseIterable {
    case ExtremeGreed = "Extreme Greed"
    case greed = "Greed"
    case fear = "Fear"
    case veryFear = "Extreme Fear"
    case neutral = "Neutral"
    
    var returnText: String {
        switch self {
        case .ExtremeGreed:
            "매우 탐욕🤩"
        case .greed:
            "탐욕😲"
        case .fear:
            "공포😈"
        case .veryFear:
            "매우 공포👿"
        case .neutral:
            "중립🤨"
        }
    }
    
    func catchText(_ text: String) -> KoreanGreed {
        for type in KoreanGreed.allCases {
            if text == type.rawValue {
                return type
            }
        }
        return .neutral
    }
}
