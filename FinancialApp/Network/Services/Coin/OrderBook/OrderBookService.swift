//
//  OrderBookService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift

final class OrderBookService {
    func getTotal(totalData: [CryptoModel]) -> Observable<Result<[[AddTradesModel]],NetworkError.CustomError>> {
        let returnObserver = totalData.compactMap {
            return self.getDetail(coinModel: $0)
        }
        
        return Observable.zip(returnObserver)
            .map { ticks in
                return .success(ticks)
            }
            .catch { error in
                return Observable.just(.failure(.notFount))
            }
    }
    
    func getDetail(coinModel: CryptoModel) -> Observable<[AddTradesModel]> {
        return NetworkManager.shared.getData(APIEndpoint.getTicks(market: coinModel.market))
            .flatMap { (response: Result<[TradesModel],NetworkError.CustomError>) -> Observable<[AddTradesModel]> in
                switch response {
                case let .success(data):
                    let coinDataWithAdditionalInfo = data.map { AddTradesModel(tradesData: $0, coinName: coinModel.korean_name, englishName: coinModel.english_name) }
                    return Observable.just(coinDataWithAdditionalInfo)
                case let .failure(error):
                    return Observable.just([])
                }
            }
    }
    
}
