//
//  APIEndpoint.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation
import Alamofire

//TODO: - 라우터패턴
enum APIEndpoint: String {
    case getTicks = "https://api.upbit.com/v1/trades/ticks?"
    case getCandle = "https://api.upbit.com/v1/candles/"
    case news = "https://openapi.naver.com/v1/search/news.json?query="
    case ai = "https://api.openai.com/v1/chat/completions"
    case feedback = "https://forms.gle/72cpe7pXSgqNTDQWA"
    
    var endPoing: String {
        return ""
    }
    
    var baseURL: String {
        return ""
    }
    
    var headers: HTTPHeaders {
        return []
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        return [:]
    }
    
}
