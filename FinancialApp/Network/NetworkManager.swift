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
protocol NetworkManagerType: AnyObject {
    
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable>(_ api: APIEndpoint) -> Observable<Result<T,NetworkError.CustomError>> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    let statusCode = NetworkError().checkErrorType(response.response?.statusCode)
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(data):
                        observer.onNext(.success(data))
                        observer.onCompleted()
                    case .failure:
                        observer.onNext(.failure(statusCode))
                    }
                }
            return Disposables.create()
        }
    }
    
    func postData<T: Decodable>(_ api: APIEndpoint) -> Observable<Result<T,NetworkError.CustomError>> {
        return Observable.create { observer in
            AF.request(api.baseURL, method: api.method, parameters: api.params, encoding: JSONEncoding.default, headers: api.headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    let statusCode = NetworkError().checkErrorType(response.response?.statusCode)
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(data):
                        observer.onNext(.success(data))
                        observer.onCompleted()
                    case .failure:
                        observer.onNext(.failure(statusCode))
                    }
                }
            return Disposables.create()
        }
    }
    
    
}
