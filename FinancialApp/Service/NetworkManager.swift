//
//  NetworkManager.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation
import Alamofire
import RxSwift
//TODO: - Router Pattern

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable>(_ url: String, headers: HTTPHeaders?) -> Observable<T> {
        return Observable.create { observer in
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case let .failure(error):
                        //TODO: - 에러 처리
                        print(error)
                    }
                }
            return Disposables.create()
        }
    }
    
}
