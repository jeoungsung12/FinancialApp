//
//  DetailWebSocketViewModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import Foundation
import RxSwift
import RxCocoa
final class DetailWebSocketViewModel: BaseViewModel {
    private let socket: WebSocketManagerType = WebSocketManager.shared
    private var disposeBag = DisposeBag()
    private let candlesRelay = BehaviorRelay<[CandleModel]>(value: [])
    
    struct Input {
        let loadTrigger: PublishRelay<String>
    }
    
    struct Output {
        let coinResult: Driver<[CandleModel]>
    }
    
    deinit {
        socket.disConnect()
        print(#function, self)
    }
    
    func transform(_ input: Input) -> Output {
        socket.messagePublisher
            .bind(with: self, onNext: { owner, candleData in
                let newCandle = owner.convertToCandle(candleData)
                var currentCandles = owner.candlesRelay.value
                
                if currentCandles.isEmpty {
                    let initialCandles = (0..<20).map { _ in
                        return CandleModel(
                            market: newCandle.market,
                            opening_price: newCandle.opening_price,
                            high_price: newCandle.high_price,
                            low_price: newCandle.low_price,
                            trade_price: newCandle.trade_price
                        )
                    }
                    currentCandles = initialCandles
                }
                if currentCandles.count >= 30 {
                    currentCandles.removeFirst()
                }
                currentCandles.append(newCandle)
                owner.candlesRelay.accept(currentCandles)
            })
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .bind(with: self, onNext: { owner, market in
                owner.socket.connect()
                owner.socket.send(market)
            })
            .disposed(by: disposeBag)
        
        return Output(
            coinResult: candlesRelay.asDriver()
        )
    }
    
    private func convertToCandle(_ data: WebSocketCandleData) -> CandleModel {
        return CandleModel(
            market: data.code,
            opening_price: 0,
            high_price: 0,
            low_price: 0,
            trade_price: data.trade_price
        )
    }
    
    func disconnectSocket() {
        socket.disConnect()
    }
}
