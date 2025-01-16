//
//  GetNameService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//
import Alamofire
import RxSwift
import RxCocoa

class GetNameService {
    static func getAllCoin() -> Observable<[GetAllCoinModel]> {
        return Observable.create { observer in
            let url = "https://api.upbit.com/v1/market/all?isDetails=False"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json"])
                .validate()
                .responseDecodable(of: [GetAllCoinModel].self) { response in
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
