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
        let chartInput : Observable<Void>
    }
    
    struct Output {
        //TODO: - 에러 처리
        let chartOutput : Observable<CoinResult>
    }
    
    func transform(input: Input) -> Output {
        let cryptoData = cryptoData.prefix(6)
        //TODO: - DispatchGroup
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] _ -> Observable<CoinResult> in
                guard self != nil else { return Observable.empty() }
                let coinResult = CandleService().getCandleList(markets: cryptoData.map { $0.market } , method: .months)
                let ticksResult = OrderBookService().getTotal(totalData: Array(cryptoData) )
                let newsResult = NewsService().getNews(query: "암호화폐", display: 3)
                return Observable.zip(coinResult, ticksResult, newsResult) { coinResult, ticksResult, newsResult in
                    return CoinResult(chartData: coinResult, newsData: newsResult, ticksData: ticksResult)
                }
            }
        
        return Output(chartOutput: chartOutput)
    }
}
