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
        let heartList: Observable<[DatabaseObject]>
    }
    
    func transform(input: Input) -> Output {
        let heartList = input.inputTrigger
            .map { _ in
                Array(Database.shared.getData())
            }
            .asObservable()
        return Output(heartList: heartList)
    }
}
