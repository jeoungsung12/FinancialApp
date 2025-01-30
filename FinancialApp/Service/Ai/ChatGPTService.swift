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
//"messages": [
//    ["role": "system", "content": "I will tell you the 1-year chart, 52-week high, and 52-week low for this cryptocurrency that I gave you. Based on the articles and information you know about this cryptocurrency, and based on the 7 types of charts that are useful for buying, 1. Tell me one similar type among the 7. When you tell me one similar type, you must tell me in English the exact words I gave you. Please explain in Korean. 2. Please give a score out of 10 for how much you recommend or do not recommend it. There is nothing I don't know. You must give a score. 3. Please cite articles, etc., to explain the reason for your recommendation or non-recommendation, and if the score for recommending is greater than the score for not recommending, explain the reason by relating it to the 7 types of charts that are similar to it. You must answer the questions I gave you unconditionally. Please speak politely in Korean."],
//    ["role": "user", "content": "SearchInfo : \(searchTitle)\(ChartInfo)"]
//]
class ChatGPTService {
    //TODO: 수정
    func requestChat<T>(search : T) -> Observable<ChatServiceModel> {
        let url = APIEndpoint.ai.rawValue
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(Bundle.main.AiAppKey)", "Content-Type" : "application/json"]
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": ""],
                ["role": "user", "content": "SearchInfo : \(search)"]
            ]
        ]
        return NetworkManager.shared.postData(url, headers: headers, params: parameters)
            .flatMap { (response: ChatServiceModel) -> Observable<ChatServiceModel> in
                return Observable.just(response)
            }
    }
    
    
}
