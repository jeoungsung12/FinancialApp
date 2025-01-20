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

enum CandleType {
    
}

class CandleService {
    static func MinuteCandle(market : String, method : String) -> Observable<[CandleMinuteModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/candles/\(method)/1?market=\(market)&count=30"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [CandleMinuteModel].self) { response in
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
    static func DayCandle(market : String, method : String) -> Observable<[CandleDayModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/candles/\(method)?market=\(market)&count=10"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .responseString { response in
//                    print(response)
                }
                .validate()
                .responseDecodable(of: [CandleDayModel].self) { response in
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
    static func WMCandle(market : String, method : String) -> Observable<[CandleWMModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/candles/\(method)?market=\(market)&count=30"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [CandleWMModel].self) { response in
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
