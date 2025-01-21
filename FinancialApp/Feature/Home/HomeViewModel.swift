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
    
    struct Input {
        let inputTrigger : Observable<Void>
    }
    
    struct Output {
        let mainList : Observable<Result<CoinResult,Error>>
    }
    
    func transform(input: Input) -> Output {
        let mainResult = input.inputTrigger
            .flatMapLatest { [weak self] _ -> Observable<Result<CoinResult, Error>> in
                guard self != nil else { return Observable.empty() }
                return Observable.combineLatest(CandleService().getCandle(market: "KRW-BTC", method: .minutes),
                    NewsService().getNews(query: "암호화폐", display: 3), OrderBookService.getAllCoin(start: 0, limit: 6)) { chart ,news, order -> Result<CoinResult, Error> in
                        return .success(CoinResult(chartData:  chart, newsData: news, orderBook: order))
                    }.catch { error in
                        return Observable.just(.failure(error))
                    }
            }
        
        return Output(mainList: mainResult)
    }
}
