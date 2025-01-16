//
//  TradesService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class TradesService {
    static func getTrades(market : String) -> Observable<[TradesModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/trades/ticks?market=\(market)&count=1"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [TradesModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
