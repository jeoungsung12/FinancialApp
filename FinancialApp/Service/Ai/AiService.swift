//
//  ChatGPTService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation
import RxSwift

class AiService {
    func requestChat(search: String, info: String) -> Observable<ChatServiceModel> {
        return NetworkManager.shared.postData(APIEndpoint.ai(search: search, info: info))
            .flatMap { (response: ChatServiceModel) -> Observable<ChatServiceModel> in
                return Observable.just(response)
            }
    }
}
