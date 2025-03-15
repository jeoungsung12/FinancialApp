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
        let chartInput : Observable<[HeartItem]>
    }
    
    struct Output {
        let chartOutput : Observable<Result<CoinResult,NetworkError.CustomError>>
    }
    
    func transform(input: Input) -> Output {
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] db -> Observable<Result<CoinResult, NetworkError.CustomError>> in
                guard let self = self else { return .just(.failure(.notFount)) }
                
                let data = cryptoData.prefix(6)
                let cryptoData: [String] = db.isEmpty ? data.map { $0.market } : db.map { $0.name }
                
                let coinResult = CandleService().getCandleList(markets: cryptoData, method: .months)
                let ticksResult = OrderBookService().getTotal(totalData: Array(data))
                let newsResult = NewsService().getNews(query: "암호화폐", display: 5)
                
                return Observable.zip(coinResult, ticksResult, newsResult)
                    .map { coinResult, ticksResult, newsResult -> Result<CoinResult, NetworkError.CustomError> in
                        switch (coinResult, ticksResult, newsResult) {
                        case let (.failure(error), _, _),
                            let (_, .failure(error), _),
                            let (_, _, .failure(error)):
                            return .failure(error)
                            
                        case let (.success(coinData), .success(ticksData), .success(newsData)):
                            let priceDict: [String: Double] = coinData
                                .flatMap { $0 }
                                .reduce(into: [String: Double]()) { dict, coin in
                                    if dict[coin.market] == nil {
                                        dict[coin.market] = coin.opening_price
                                    }
                                }
                            let priceList = db.compactMap { priceDict[$0.name] }
                            let rateResult = self.calculateRate(priceList, db)
                            
                            return .success(CoinResult(chartData: coinData, newsData: newsData, ticksData: ticksData, rate: rateResult))
                        }
                    }
            }
        
        return Output(chartOutput: chartOutput)
    }
    
    
    private func calculateRate(_ openingPrices: [Double],_ db: [HeartItem]) -> Double {
        let heartList = db
        guard !heartList.isEmpty, !openingPrices.isEmpty else { return 0 }
        
        var totalInvested: Double = 0
        var totalCurrentValue: Double = 0
        
        for (index, heartItem) in heartList.enumerated() {
            guard let quantity = Double(heartItem.quantity), let price = Double(heartItem.price) else { return 0 }
            if quantity > 0 && price > 0, index < openingPrices.count {
                let buyPrice = price
                let quantity = quantity
                let currentPrice = openingPrices[index]
                
                totalInvested += buyPrice * quantity
                totalCurrentValue += currentPrice * quantity
            }
        }
        
        guard totalInvested > 0 else { return 0 }
        
        let rate = ((totalCurrentValue - totalInvested) / totalInvested) * 100
        return rate
    }
    
}
