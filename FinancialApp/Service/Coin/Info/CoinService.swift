//
//  CoinService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation
import RxSwift

final class CoinService {
    
    func getFearGreedIndex() -> Observable<Result<GreedModel,NetworkError.CustomError>> {
        return NetworkManager.shared.getData(APIEndpoint.greedIndex)
            .flatMap { (response: Result<GreedModel,NetworkError.CustomError>) -> Observable<Result<GreedModel,NetworkError.CustomError>> in
                switch response {
                case let .success(data):
                    return Observable.just(.success(data))
                case let .failure(error):
                    return Observable.just(.failure(error))
                }
        }
    }
    
}
