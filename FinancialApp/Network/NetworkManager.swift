//
//  NetworkManager.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkManagerType: AnyObject {
    func getData<T:Decodable, U:Router>(_ api: U) -> Observable<T>
    func postData<T: Decodable, U: Router>(_ api: U) -> Observable<T>
}

final class NetworkManager: NetworkManagerType {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable, U: Router>(_ api: U) -> Observable<T> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure:
                        let statusCode = NetworkError().checkErrorType(response.response?.statusCode)
                        observer.onError(statusCode)
                    }
                }
            return Disposables.create()
        }
    }
    
    func postData<T: Decodable, U: Router>(_ api: U) -> Observable<T> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, parameters: api.params, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(data):
                        observer.onNext((data))
                        observer.onCompleted()
                    case .failure:
                        let statusCode = NetworkError().checkErrorType(response.response?.statusCode)
                        observer.onError((statusCode))
                    }
                }
            return Disposables.create()
        }
    }
    
    
}
