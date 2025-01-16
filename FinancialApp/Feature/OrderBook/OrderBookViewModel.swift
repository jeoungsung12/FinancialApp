//
//  OrderBookViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class OrderBookViewModel {
    private let disposeBag = DisposeBag()
    let inputTrigger = PublishSubject<Void>()
    let MainTable: BehaviorRelay<[[AddTradesModel]]> = BehaviorRelay(value: [])
    
    //페이징 변수
    private let initialLoadStart = 0
    private let initialLoadLimit = 15
    private var currentPage = 0
    
    init() {
        //MARK: - GetCoinInfo
        inputTrigger
            .subscribe { _ in
                OrderBookService.getAllCoin(start: self.initialLoadStart, limit: self.initialLoadLimit)
                    .map { coinData -> [[AddTradesModel]] in
                        return coinData
                    }
                    .bind(to: self.MainTable)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
