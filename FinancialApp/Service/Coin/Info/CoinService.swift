//
//  CoinService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/01.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class CoinService {
    
    func getFearGreedIndex() -> Observable<GreedModel> {
        return NetworkManager.shared.getData(APIEndpoint.greedIndex)
            .flatMap { (response: GreedModel) in
            return Observable.just(response)
        }
    }
    
}
