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
    static func getNews(query : String, start : Int) -> Observable<[NewsItems]> {
        return Observable.create { observer in
            let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = "https://openapi.naver.com/v1/search/news.json?query=\(queryEncoded)&display=15&start=\(start)&sort=sim"
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["accept" : "application/json", "X-Naver-Client-Id" : Bundle.main.NewsClientID, "X-Naver-Client-Secret" : Bundle.main.NewsClientSecret])
                .validate()
                .responseDecodable(of: NewsServiceModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data.items ?? [])
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
