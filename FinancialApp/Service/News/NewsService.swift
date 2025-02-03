//
//  NewsService.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift

final class NewsService {
    func getNews(query: String, display: Int) -> Observable<Result<[NewsItems],NetworkError.CustomError>> {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return NetworkManager.shared.getData(APIEndpoint.news(search: queryEncoded, display: display))
            .flatMap { (response: Result<[NewsItems],NetworkError.CustomError>) -> Observable<Result<[NewsItems],NetworkError.CustomError>> in
                switch response {
                case let .success(data):
                    return Observable.just(.success(data))
                case let .failure(error):
                    return Observable.just(.failure(error))
                }
            }
    }
    
}
