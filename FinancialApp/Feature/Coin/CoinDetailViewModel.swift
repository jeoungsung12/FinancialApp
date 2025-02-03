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
        let chartOutput : Observable<Result<CoinDetailModel,NetworkError.CustomError>>
    }
    
    func transform(input: Input) -> Output {
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] input -> Observable<Result<CoinDetailModel,NetworkError.CustomError>> in
                guard self != nil, let englishName = input.name, let data = cryptoData.filter({ $0.english_name == englishName }).first else { return Observable.empty() }
                let coinResult = CandleService().getCandle(market: data.market, method: input.type)
                    .map { (response: Result<[[CandleModel]],NetworkError.CustomError>) -> Result<[[CandleModel]],NetworkError.CustomError>  in
                        switch response {
                        case let .success(data):
                            return .success(data)
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
                
                let ticksResult = OrderBookService().getDetail(coinModel: data)
                    .map { (response: Result<[[AddTradesModel]],NetworkError.CustomError>) -> Result<[[AddTradesModel]],NetworkError.CustomError> in
                        switch response {
                        case let .success(data):
                            return .success(data)
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
                
                let newsResult = NewsService().getNews(query: data.korean_name, display: 5)
                    .map { (response: Result<[NewsItems],NetworkError.CustomError>) -> Result<[NewsItems],NetworkError.CustomError>  in
                        switch response {
                        case let .success(data):
                            return .success(data)
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
                
                let greedResult = CoinService().getFearGreedIndex()
                    .map { (response: Result<GreedModel,NetworkError.CustomError>) -> Result<GreedModel,NetworkError.CustomError>  in
                        switch response {
                        case let .success(data):
                            return .success(data)
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
                
                return Observable.zip(coinResult, ticksResult, newsResult, greedResult) { coinResult, ticksResult, newsResult, greedResult -> Result<CoinDetailModel,NetworkError.CustomError> in
                    var coinDetail = CoinDetailModel(chartData: nil, newsData: nil, ticksData: nil, greedIndex: nil)
                    switch coinResult {
                    case let .success(data):
                        coinDetail.chartData = data
                    case let .failure(error):
                        return .failure(error)
                    }
                    
                    switch ticksResult {
                    case let .success(data):
                        coinDetail.ticksData = data
                    case let .failure(error):
                        return .failure(error)
                    }
                    
                    switch newsResult {
                    case let .success(data):
                        coinDetail.newsData = data
                    case let .failure(error):
                        return .failure(error)
                    }
                    
                    switch greedResult {
                    case let .success(data):
                        coinDetail.greedIndex = data
                    case let .failure(error):
                        return .failure(error)
                    }
                    return .success(coinDetail)
                }
            }
        
        return Output(chartOutput: chartOutput)
    }
}
