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
    
    func getData<T: Decodable>(_ api: APIEndpoint) -> Observable<T> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
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
    
    func postData<T: Decodable>(_ api: APIEndpoint) -> Observable<T> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, parameters: api.params, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
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
