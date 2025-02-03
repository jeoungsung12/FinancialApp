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
        return Observable.zip(returnObserver).map { observer in
            return observer[0]
        }
    }
    
    func getCandle(market : String, method : CandleType) -> Observable<Result<[[CandleModel]],NetworkError.CustomError>> {
        return NetworkManager.shared.getData(APIEndpoint.getCandle(method: method, market: market))
            .flatMap { (result: Result<[CandleModel],NetworkError.CustomError>) -> Observable<Result<[[CandleModel]],NetworkError.CustomError>> in
                switch result {
                case let .success(data):
                    return Observable.just(.success([data]))
                case let .failure(error):
                    return Observable.just(.failure(error))
                }
            }
    }
    
}
