//
//  ChatGPTService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Alamofire
class AiService {
    //TODO: 수정
    func requestChat(search: String, info: String) -> Observable<ChatServiceModel> {
        let url = APIEndpoint.ai.rawValue
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(Bundle.main.AiAppKey)", "Content-Type" : "application/json"]
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "너는 코인 분석 전문가야."],
                ["role": "user", "content": search + info]
            ]
        ]
        return NetworkManager.shared.postData(url, headers: headers, params: parameters)
            .flatMap { (response: ChatServiceModel) -> Observable<ChatServiceModel> in
                return Observable.just(response)
            }
    }
    
    
}
