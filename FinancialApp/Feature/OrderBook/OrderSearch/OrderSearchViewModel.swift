//
//  OrderSearchViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class OrderSearchViewModel {
    private let disposeBag = DisposeBag()
    
    //검색
    let searchInputrigger = PublishSubject<String>()
    let searchResult : PublishSubject<[AddTradesModel]> = PublishSubject()
    
    init() {
        //MARK: - SearchCoinInfo
        searchInputrigger.flatMapLatest { coinName in
            return SearchOrder.searchCoin(searchName: coinName)
        }
        .bind(to: searchResult)
        .disposed(by: disposeBag)
    }
}
