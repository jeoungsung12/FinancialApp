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
    static func getAllCoin(start: Int, limit: Int) -> Observable<[[CoinDataWithAdditionalInfo]]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/market/all?isDetails=False"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [GetAllCoinModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        self.getDetail(data, start: start, limit: limit, delayInterval: 0.1) { result in
                            switch result {
                            case .success(let coinDataArray):
                                observer.onNext(coinDataArray)
                                observer.onCompleted()
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //쓰레드 풀
    private static let threadPool = DispatchQueue(label: "com.example.coinDataThreadPool", attributes: .concurrent)

    private static func getDetail(_ data: [GetAllCoinModel], start: Int, limit: Int, delayInterval: TimeInterval, completion: @escaping (Result<[[CoinDataWithAdditionalInfo]], Error>) -> Void) {
        var coinDataArray: [[CoinDataWithAdditionalInfo]] = []
        let group = DispatchGroup()

        let slicedData = data[start..<limit]
//        print("시작 \(start), 끝 \(limit)")

        for (index, coinModel) in slicedData.enumerated() {
            group.enter()
            let delay = delayInterval * TimeInterval(index)
            threadPool.asyncAfter(deadline: .now() + delay) {
                let url = "https://api.upbit.com/v1/ticker?markets=\(coinModel.market)"
                AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                    .validate()
                    .responseDecodable(of: [CoinData].self) { response in
                        defer { group.leave() }
                        switch response.result {
                        case .success(let coinData):
                            let coinDataWithAdditionalInfo = coinData.map { CoinDataWithAdditionalInfo(coinData: $0, coinName: coinModel.korean_name) }
                            DispatchQueue.main.async {
                                coinDataArray.append(coinDataWithAdditionalInfo)
                            }
                        case .failure(let error):
                            print("\(error)")
                        }
                    }
            }
        }
        group.notify(queue: .main) {
            completion(.success(coinDataArray))
        }
    }
}
