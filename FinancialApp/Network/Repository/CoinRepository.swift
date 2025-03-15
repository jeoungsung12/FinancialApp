//
//  CoinRepository.swift
//  FinancialApp
//
//  Created by 정성윤 on 3/15/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol CoinRepositoryType {
    func getTotal(totalData: [CryptoModel]) -> Observable<[[AddTradesModel]]>
    func getDetail(coinModel: CryptoModel) -> Observable<[AddTradesModel]>
    func getCandleList(markets : [String], method : CandleType) -> Observable<[[CandleModel]]>
    func getCandle(market : String, method : CandleType) -> Observable<[CandleModel]>
    func getFearGreedIndex() -> Observable<GreedModel>
}

final class CoinRepository: CoinRepositoryType {
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    func getTotal(totalData: [CryptoModel]) -> Observable<[[AddTradesModel]]> {
        return Observable.empty()
    }
    
    func getDetail(coinModel: CryptoModel) -> Observable<[AddTradesModel]> {
        return Observable.empty()
    }
    
    func getCandleList(markets: [String], method: CandleType) -> Observable<[[CandleModel]]> {
        return Observable.empty()
    }
    
    func getCandle(market: String, method: CandleType) -> Observable<[CandleModel]> {
        return Observable.empty()
    }
    
    func getFearGreedIndex() -> RxSwift.Observable<GreedModel> {
        return networkManager.getData(CoinRouter.greedIndex)
    }
    
}
