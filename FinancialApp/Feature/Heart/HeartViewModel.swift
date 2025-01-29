//
//  HeartViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/02.
//

import Foundation
import RxSwift
import RxCocoa

final class HeartViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let inputTrigger : Observable<Void>
    }
    
    struct Output {
        let heartList: Observable<[[AddTradesModel]]>
    }
    
    func transform(input: Input) -> Output {
        let database = Database.shared.heartList
        let model = changeToModel(database)
        let heartList = input.inputTrigger.flatMapLatest { result in
            return OrderBookService().getTotal(totalData: model)
        }
        
        return Output(heartList: heartList)
    }
    
    private func changeToModel(_ database: [String]) -> [CryptoModel] {
        var model: [CryptoModel] = []
        for db in database {
            model += cryptoData.filter { $0.market == db }
        }
        return model
    }
    
}
