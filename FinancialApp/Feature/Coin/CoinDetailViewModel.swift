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
        let chartInput : Observable<CoinDetailInput>
    }
    
    struct Output {
        //TODO: - 에러 처리
        let chartOutput : Observable<CoinDetailModel>
    }
    
    func transform(input: Input) -> Output {
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] input -> Observable<CoinDetailModel> in
                guard self != nil, let englishName = input.name, let data = cryptoData.filter({ $0.english_name == englishName }).first else { return Observable.empty() }
                let coinResult = CandleService().getCandle(market: data.market, method: input.type)
                let ticksResult = OrderBookService().getDetail(coinModel: data)
                let newsResult = NewsService().getNews(query: data.korean_name, display: 5)
                let greedResult = CoinService().getFearGreedIndex()
                return Observable.zip(coinResult, ticksResult, newsResult, greedResult) { coinResult, ticksResult, newsResult, greedResult in
                    return CoinDetailModel(chartData: [coinResult], newsData: newsResult, ticksData: [ticksResult], greedIndex: greedResult)
                }
            }
        return Output(chartOutput: chartOutput)
    }
}
