//
//  SearchResult.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/23.
//

import Foundation

struct SearchResult : Hashable{
    let coinData : [CoinDataWithAdditionalInfo]
    let orderData : [AddTradesModel]
}
