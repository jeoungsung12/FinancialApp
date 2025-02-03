//
//  CandleService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/04.
//

import Foundation
import RxSwift

class CandleService {
    
    func getCandleList(markets : [String], method : CandleType) -> Observable<[[CandleModel]]> {
        let returnObserver = markets.map { market in
            return self.getCandle(market: market, method: method)
        }
        return Observable.zip(returnObserver)
    }
    
    func getCandle(market : String, method : CandleType) -> Observable<[CandleModel]> {
        return NetworkManager.shared.getData(APIEndpoint.getCandle(method: method, market: market))
            .flatMap { (result: [CandleModel]) -> Observable<[CandleModel]> in
                return Observable.just(result)
            }
    }
    
}
