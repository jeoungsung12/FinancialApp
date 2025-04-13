//
//  APIEndpoint.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case getTicks(market: String)
    case getCandle(method: CandleType, market: String)
    case news(search: String, display: Int)
    case ai(search: String, info: String)
    case greedIndex
    case feedback
    
    var baseURL: String {
        switch self {
        case .getTicks(let market):
            endPoint + path + "market=\(market)&count=1"
        case .getCandle(let method, let market):
            endPoint + path + method.rawValue + "\(market)&count=30"
        case .news(let search, let display):
            endPoint + path + "\(search)&display=\(display)&sort=sim"
        case .ai:
            endPoint + path
        case .greedIndex:
            endPoint + path
        case .feedback:
            endPoint + path
        }
    }
    
    var endPoint: String {
        switch self {
        case .getTicks:
            "https://api.upbit.com/v1/"
        case .getCandle:
            "https://api.upbit.com/v1/"
        case .news:
            "https://openapi.naver.com/v1/"
        case .ai:
            "https://api.openai.com/v1/"
        case .greedIndex:
            "https://api.alternative.me/"
        case .feedback:
            "https://forms.gle/"
        }
    }
    
    var path: String {
        switch self {
        case .getTicks:
            "trades/ticks?"
        case .getCandle:
            "candles/"
        case .news:
            "search/news.json?query="
        case .ai:
            "chat/completions"
        case .greedIndex:
            "fng/"
        case .feedback:
            "72cpe7pXSgqNTDQWA"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getTicks:
            ["Content-Type" : "application/json"]
        case .getCandle:
            ["Content-Type" : "application/json"]
        case .news:
            [
                "accept" : "application/json",
                "X-Naver-Client-Id" : Bundle.main.NewsClientID,
                "X-Naver-Client-Secret" : Bundle.main.NewsClientSecret
            ]
        case .ai:
            [
                "Authorization" : "Bearer \(Bundle.main.AiAppKey)",
                "Content-Type" : "application/json"
            ]
        case .greedIndex:
            ["Content-Type" : "application/json"]
        case .feedback:
            []
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getTicks:
            .get
        case .getCandle:
            .get
        case .news:
            .get
        case .ai:
            .post
        case .greedIndex:
            .get
        case .feedback:
            .get
        }
    }
    
    var params: Parameters {
        switch self {
        case .getTicks:
            [:]
        case .getCandle:
            [:]
        case .news:
            [:]
        case .ai(let search, let info):
            [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "system", "content": "너는 코인 분석 전문가야."],
                    ["role": "user", "content": search + info]
                ]
            ]
        case .greedIndex:
            [:]
        case .feedback:
            [:]
        }
    }
    
}
