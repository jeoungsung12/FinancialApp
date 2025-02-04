//
//  PortfolioViewModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import Foundation
import RxSwift

final class PortfolioViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let portfolioInput : Observable<[HeartItem]>
    }
    
    struct Output {
        let portfolioOutput : Observable<Result<[PortfolioModel],NetworkError.CustomError>>
    }
    
    func transform(input: Input) -> Output {
        let chartOutput = input.portfolioInput
            .flatMapLatest { [weak self] db -> Observable<Result<[PortfolioModel],NetworkError.CustomError>> in
                guard self != nil else { return Observable.empty() }
                let cryptoArray: [String] = (db.isEmpty) ? [] : db.map ({ $0.name })
                let fillteredData = cryptoData.filter { cryptoArray.contains($0.market) }
                
                
                let ticksObservable = OrderBookService().getTotal(totalData: Array(fillteredData))
                    .map { (response: Result<[[AddTradesModel]],NetworkError.CustomError>) -> Result<[[AddTradesModel]],NetworkError.CustomError> in
                        switch response {
                        case let .success(data):
                            return .success(data)
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
                
                
                return ticksObservable.flatMap { (ticksData: Result<[[AddTradesModel]], NetworkError.CustomError>) -> Observable<Result<[PortfolioModel], NetworkError.CustomError>> in
                    guard let self = self else { return .just(.failure(.notFount)) }
                    
                    switch ticksData {
                    case let .success(data):
                        let priceDict: [String: Double] = data
                            .flatMap { $0 }
                            .reduce(into: [String: Double]()) { dict, tick in
                                dict[tick.tradesData.market] = tick.tradesData.trade_price
                            }
                        
                        let priceList = db.compactMap { priceDict[$0.name] }
                        let rateList = self.calculateRate(priceList, db)
                        
                        let portfolioModels = zip(db, priceList).compactMap { (dbItem, openPrice) -> PortfolioModel? in
                            guard let quantity = Double(dbItem.quantity),
                                  let price = Double(dbItem.price),
                                  let name = cryptoData.first(where: { $0.market == dbItem.name }) else { return nil }
                            
                            return PortfolioModel(
                                name: name.korean_name,
                                quantity: quantity,
                                purchasePrice: price,
                                currentPrice: openPrice,
                                rate: rateList
                            )
                        }
                        
                        return .just(.success(portfolioModels))
                        
                    case .failure(let error):
                        return .just(.failure(error))
                    }
                }
                
            }
        return Output(portfolioOutput: chartOutput)
    }
    
    //TODO:- 수정
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
