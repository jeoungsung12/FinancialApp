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
    case seconds = "seconds/1?market="
    case minutes = "minutes/1?market="
    case days = "days/1?market="
    case weeks = "weeks/1?market="
    case months = "months/1?market="
    case years = "years/1?market="
}

class CandleService {
    
    func getCandle(market : String, method : CandleType) -> Observable<[CandleModel]> {
        let url = APIEndpoint.getCandle.rawValue + method.rawValue + "\(market)&count=50"
        let headers: HTTPHeaders = ["accept" : "application/json"]
        return NetworkManager.shared.getData(url, headers: headers)
            .flatMap { (result: [CandleModel]) -> Observable<[CandleModel]> in
                Observable.just(result)
            }
    }
    
}
