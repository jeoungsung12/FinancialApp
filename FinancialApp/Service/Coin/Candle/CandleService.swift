//
//  CandleService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/04.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum CandleType: String {
    case seconds = "seconds?market="
    case minutes = "minutes?market="
    case days = "days?market="
    case weeks = "weeks?market="
    case months = "months?market="
    case years = "years?market="
}

class CandleService {
    
    func getCandle(market : String, method : CandleType) -> Observable<[CandleModel]> {
        let url = APIEndpoint.getCandle.rawValue + method.rawValue + "\(market)&count=50"
        let headers: HTTPHeaders = ["accept" : "application/json"]
        return NetworkManager.shared.getData(url, headers: headers)
            .flatMap { (result: [CandleModel]) -> Observable<[CandleModel]> in
                return Observable.just(result)
            }
    }
    
}
