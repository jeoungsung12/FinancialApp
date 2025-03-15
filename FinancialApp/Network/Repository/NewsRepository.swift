//
//  NewsRepository.swift
//  FinancialApp
//
//  Created by 정성윤 on 3/15/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsRepositoryType {
    func getNews(query: String, display: Int) -> Observable<[NewsItems]>
}

final class NewsRepository: NewsRepositoryType {
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    func getNews(query: String, display: Int) -> Observable<[NewsItems]> {
        return networkManager.getData(NewsRouter.news(search: query, display: display))
    }
    
}
