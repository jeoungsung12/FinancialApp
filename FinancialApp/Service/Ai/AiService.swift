//
//  ChatGPTService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation
import RxSwift

final class AiService {
    func requestChat(search: String, info: String) -> Observable<Result<ChatServiceModel,NetworkError.CustomError>> {
        return NetworkManager.shared.postData(APIEndpoint.ai(search: search, info: info))
            .flatMap { (response: Result<ChatServiceModel,NetworkError.CustomError>) -> Observable<Result<ChatServiceModel,NetworkError.CustomError>> in
                switch response {
                case let .success(data):
                    return Observable.just(.success(data))
                case let .failure(error):
                    return Observable.just(.failure(error))
                }
            }
    }
}
