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
