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
        //TODO: - 에러 처리
        let chartOutput : Observable<CoinResult>
    }
    
    func transform(input: Input) -> Output {
        //TODO: - DispatchGroup
        let chartOutput = input.chartInput
            .flatMapLatest { [weak self] db -> Observable<CoinResult> in
                let data = cryptoData.prefix(6)
                let cryptoData: [String] = (db.isEmpty) ? data.map { $0.market } : db.map ({ $0.name })
                
                guard self != nil else { return Observable.empty() }
                let coinResult = CandleService().getCandleList(markets: cryptoData , method: .months)
                let ticksResult = OrderBookService().getTotal(totalData: Array(data))
                let newsResult = NewsService().getNews(query: "암호화폐", display: 5)
                
                return Observable.zip(coinResult, ticksResult, newsResult) { coinResult, ticksResult, newsResult in
                    let priceDict: [String: Double] = coinResult
                        .map { $0 }
                        .reduce(into: [String: Double]()) { dict, coin in
                            guard let coinData = coin.first else { return }
                            dict[coinData.market] = coinData.opening_price
                        }
                    
                    let priceList = db.compactMap { priceDict[$0.name] }
                    let rateResult = self?.calculateRate(priceList, db)
                    return CoinResult(chartData: coinResult, newsData: newsResult, ticksData: ticksResult, rate: rateResult ?? 0)
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
