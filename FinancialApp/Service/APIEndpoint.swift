//
//  APIEndpoint.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import Foundation

//TODO: - 라우터패턴
enum APIEndpoint: String {
    case getCandle = "https://api.upbit.com/v1/candles/"
    case news = "https://openapi.naver.com/v1/search/news.json?query="
}
