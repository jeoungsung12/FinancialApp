//
//  MainDetailViewModel.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/04.
//

import Foundation
import RxSwift
import RxCocoa

class MainDetailViewModel {
    private let disposeBag = DisposeBag()
    let MinuteTrigger = PublishSubject<[String]>()
    let MinuteResult : PublishSubject<[CandleModel]> = PublishSubject()
    
    let DayTrigger = PublishSubject<[String]>()
    let DayResult : PublishSubject<[CandleModel]> = PublishSubject()

    let WMTrigger = PublishSubject<[String]>()
    let WMResult : PublishSubject<[CandleModel]> = PublishSubject()
    
    let tradeTrigger = PublishSubject<String>()
    let tradeResult : PublishSubject<[TradesModel]> = PublishSubject()
    init() {
//        MinuteTrigger.flatMapLatest { requestInfo in
//            return CandleService.getCandle(market: requestInfo[0], method: requestInfo[1])
//        }
//        .bind(to: MinuteResult)
//        .disposed(by: disposeBag)
//        
//        DayTrigger.flatMapLatest { requestInfo in
//            return CandleService.DayCandle(market: requestInfo[0], method: requestInfo[1])
//        }
//        .bind(to: DayResult)
//        .disposed(by: disposeBag)
//        
//        WMTrigger.flatMapLatest { requestInfo in
//            return CandleService.WMCandle(market: requestInfo[0], method: requestInfo[1])
//        }
//        .bind(to: WMResult)
//        .disposed(by: disposeBag)
//        
//        tradeTrigger.flatMapLatest { market in
//            return TradesService.getTrades(market: market)
//        }
//        .bind(to: tradeResult)
//        .disposed(by: disposeBag)
    }
}
