//
//  NewsService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift

class NewsService {
    func getNews(query: String, display: Int) -> Observable<[NewsItems]> {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return NetworkManager.shared.getData(APIEndpoint.news(search: queryEncoded, display: display))
            .flatMap { (result: NewsServiceModel) -> Observable<[NewsItems]> in
                return Observable.just(result.items)
            }
    }
    
}
