//
//  GetImageService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class GetImageService {
    static func getCoin(englishName : String) -> Observable<GetImageModel> {
        return Observable.create { observer in
            let url = "https://api.coinpaprika.com/v1/coins"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [GetPaprikaModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        for coin in data {
                            if coin.name == englishName{
                                self.getLogo(coin) { result in
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
    private static func getLogo(_ Data: GetPaprikaModel, completion: @escaping (Result<GetImageModel, Error>) -> Void) {
        var coinDataArray : GetImageModel = GetImageModel(id: nil, name: nil, symbol: nil, parent: nil, rank: nil, isNew:  nil, isActive: nil, type: nil, logo: nil, tags: nil, team: nil, description: nil, message: nil, openSource: nil, hardwareWallet: nil, started_at: nil, development_status: nil, proof_type: nil, org_structure: nil, hash_algorithm: nil, contract: nil, platform: nil, contracts: nil, links: nil, links_extended: nil, whitepaper: nil, first_data_at: nil, last_data_at: nil)
        let group = DispatchGroup()
        group.enter()
        if let id = Data.id {
            let url = "https://api.coinpaprika.com/v1/coins/\(id)"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: GetImageModel.self) { response in
                    defer { group.leave() }
                    switch response.result {
                    case .success(let coinData):
                        coinDataArray = coinData
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
