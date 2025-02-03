//
//  OrderBookService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift

class OrderBookService {
    func getTotal(totalData: [CryptoModel]) -> Observable<[[AddTradesModel]]> {
        let returnObserver = totalData.compactMap {
            return self.getDetail(coinModel: $0)
        }
        return Observable.zip(returnObserver)
    }
    
    func getDetail(coinModel: CryptoModel) -> Observable<[AddTradesModel]> {
        return NetworkManager.shared.getData(APIEndpoint.getTicks(market: coinModel.market))
            .flatMap { (response: [TradesModel]) -> Observable<[AddTradesModel]> in
                let coinDataWithAdditionalInfo = response.map { AddTradesModel(tradesData: $0, coinName: coinModel.korean_name, englishName: coinModel.english_name) }
                return Observable.just(coinDataWithAdditionalInfo)
            }
    }
}
