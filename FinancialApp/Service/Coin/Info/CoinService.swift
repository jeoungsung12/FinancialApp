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
        let url = "https://api.alternative.me/fng/"
        return NetworkManager.shared.getData(url, headers: nil)
            .flatMap { (response: GreedModel) in
            return Observable.just(response)
        }
    }
    
}
