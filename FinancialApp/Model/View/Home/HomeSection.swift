//
//  HomeSection.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation

enum HomeSection: Hashable {
    case banner
    case info
    case category
    case horizotional
    case vertical
}

enum HomeItem: Hashable {
    case chart([CandleModel])
    case infoData(InfoDataModel)
    case newsList(NewsItems)
    case Ads(String)
    case orderBook([AddTradesModel])
}

struct InfoDataModel: Hashable {
    let greed: GreedModel
    let loan: [LoanModel]
    let exchange: [FinancialModel]
    let inter: [InternationalModel]
    
    func data(index: Int) -> Any {
        if index == 0 {
            return self.greed
        } else if index == 1 {
            return self.loan
        } else if index == 2 {
            return self.exchange
        } else {
            return self.inter
        }
    }
}
