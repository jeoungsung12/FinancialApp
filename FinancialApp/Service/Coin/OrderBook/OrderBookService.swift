//
//  OrderBookService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class OrderBookService {
    func getTotal(totalData: [CryptoModel]) -> Observable<[[AddTradesModel]]> {
        let returnObserver = totalData.compactMap {
            return self.getDetail(coinModel: $0)
        }
        return Observable.zip(returnObserver)
    }
    
    //TODO: - 변경
    //체결보기
    func getDetail(coinModel: CryptoModel) -> Observable<[AddTradesModel]> {
        let url = APIEndpoint.getTicks.rawValue + "market=\(coinModel.market)&count=1"
        let headers: HTTPHeaders = ["accept" : "application/json"]
        return NetworkManager.shared.getData(url, headers: headers)
            .flatMap { (response: [TradesModel]) -> Observable<[AddTradesModel]> in
                let coinDataWithAdditionalInfo = response.map { AddTradesModel(tradesData: $0, coinName: coinModel.korean_name, englishName: coinModel.english_name) }
                return Observable.just(coinDataWithAdditionalInfo)
            }
    }
    
    //호가 정보조회
    static func getOrderBook(market : String) -> Observable<[OrderBookModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/orderbook?markets=\(market)"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [OrderBookModel].self) { response in
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
