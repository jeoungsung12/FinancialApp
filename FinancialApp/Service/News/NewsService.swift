//
//  NewsService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class NewsService {
    func getNews(query: String, display: Int) -> Observable<[NewsItems]> {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url =
        APIEndpoint.news.rawValue + "\(queryEncoded)&display=\(display)&sort=sim"
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "X-Naver-Client-Id" : Bundle.main.NewsClientID,
            "X-Naver-Client-Secret" : Bundle.main.NewsClientSecret
        ]
        return NetworkManager.shared.getData(url, headers: headers)
            .flatMap { (result: NewsServiceModel) -> Observable<[NewsItems]> in
                Observable.just(result.items)
            }
    }
    
}
