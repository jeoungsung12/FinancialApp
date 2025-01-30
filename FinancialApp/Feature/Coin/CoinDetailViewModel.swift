//
//  CoinDetailViewModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import RxSwift

final class CoinDetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let chartInput : Observable<String?>
    }
    
    struct Output {
        //TODO: - 에러 처리
        let chartOutput : Observable<CoinResult>
    }
    
    func transform(input: Input) -> Output {
        //TODO: - DispatchGroup
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] englishName -> Observable<CoinResult> in
                guard self != nil, let englishName = englishName, let data = cryptoData.filter({ $0.english_name == englishName }).first else { return Observable.empty() }
                let coinResult = CandleService().getCandle(market: data.market, method: .days)
                let ticksResult = OrderBookService().getDetail(coinModel: data)
                let newsResult = NewsService().getNews(query: data.korean_name, display: 5)
                return Observable.zip(coinResult, ticksResult, newsResult) { coinResult, ticksResult, newsResult in
                    return CoinResult(chartData: [coinResult], newsData: newsResult, ticksData: [ticksResult], rate: 0)
                }
            }
        return Output(chartOutput: chartOutput)
    }
}
