//
//  HomeViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/14.
//

import RxSwift
import RxCocoa
import Foundation

final class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    lazy var categoryList: Observable<[CategoryList]> = {
        return setCategory()
    }()
    
    struct Input {
        let inputTrigger : Observable<Void>
    }
    struct Output {
        let mainList : Observable<Result<CoinResult,Error>>
    }
    func transform(input: Input) -> Output {
        let categoryListObservable = categoryList.asObservable()
        let mainResult = input.inputTrigger
            .flatMapLatest { [weak self] _ -> Observable<Result<CoinResult, Error>> in
                guard self != nil else { return Observable.empty() }
                return Observable.combineLatest(
                    categoryListObservable,
                    NewsService.getNews(query: "암호화폐", start: 1), CoinService.getAllCoin(start: 0, limit: 15), OrderBookService.getAllCoin(start: 0, limit: 15)) { category, news, coin, order -> Result<CoinResult, Error> in
                        return .success(CoinResult(category: category, newsData: news, coinData: coin, orderBook: order))
                    }.catch { error in
                        return Observable.just(.failure(error))
                    }
            }
        
        return Output(mainList: mainResult)
    }
}
extension HomeViewModel {
    private func setCategory() -> BehaviorSubject<[CategoryList]> {
        let category = [
            CategoryList(btnImage: "AiIcon", btnLabel: "Ai분석"),
            CategoryList(btnImage: "ChartIcon", btnLabel: "차트"),
            CategoryList(btnImage: "NewsIcon", btnLabel: "뉴스"),
            CategoryList(btnImage: "OrderBookIcon", btnLabel: "호가")
        ]
        return BehaviorSubject(value: category)
    }
}
