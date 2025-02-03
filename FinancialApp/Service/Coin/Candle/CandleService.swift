//
//  CandleService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/04.
//

import Foundation
import RxSwift

final class CandleService {
    
    func getCandleList(markets : [String], method : CandleType) -> Observable<Result<[[CandleModel]],NetworkError.CustomError>> {
        let returnObserver = markets.map { market in
            return self.getCandle(market: market, method: method)
        }
        return Observable.zip(returnObserver)
            .map { candles in
                return .success(candles)
            }
            .catch { error in
                return Observable.just(.failure(.notFount))
            }
    }
    
    func getCandle(market : String, method : CandleType) -> Observable<[CandleModel]> {
        return NetworkManager.shared.getData(APIEndpoint.getCandle(method: method, market: market))
            .flatMap { (result: Result<[CandleModel], NetworkError.CustomError>) -> Observable<[CandleModel]> in
                switch result {
                case .success(let data):
                    return Observable.just(data)
                case .failure:
                    return Observable.just([])
                }
            }
    }
    
}
