//
//  SearchOrder.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//
import Foundation
import RxCocoa
import RxSwift
import Alamofire

class SearchOrder {
    static func searchCoin(searchName : String) -> Observable<[AddTradesModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/market/all?isDetails=False"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [GetAllCoinModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        for coin in data {
                            if coin.korean_name == searchName || coin.english_name == searchName {
                                self.searchDetail(coin) { result in
                                    switch result {
                                    case .success(let coinDataArray):
                                        observer.onNext(coinDataArray)
                                        observer.onCompleted()
                                    case .failure(let error):
                                        observer.onError(error)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    private static func searchDetail(_ Data: GetAllCoinModel, completion: @escaping (Result<[AddTradesModel], Error>) -> Void) {
        var coinDataArray : [AddTradesModel] = []
        let group = DispatchGroup()
        group.enter()
        if let market = Data.market {
            let url = "https://api.upbit.com/v1/ticker?markets=\(market)"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [TradesModel].self) { response in
                    defer { group.leave() }
                    switch response.result {
                    case .success(let coinData):
                        if let coinName = Data.korean_name,
                           let english = Data.english_name{
                            let coinDataWithAdditionalInfo = coinData.map { AddTradesModel(tradesData: $0, coinName: coinName, englishName : english) }
                            coinDataArray = coinDataWithAdditionalInfo
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                }
        }
        group.notify(queue: .main) {
            completion(.success(coinDataArray))
        }
    }
}
