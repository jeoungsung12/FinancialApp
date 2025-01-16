//
//  SearchViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/02.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    //검색
    let searchInputrigger = PublishSubject<String>()
    let searchResult : PublishSubject<[CoinDataWithAdditionalInfo]> = PublishSubject()
    
    init() {
        //MARK: - SearchCoinInfo
        searchInputrigger.flatMapLatest { coinName in
            return SearchCoin.searchCoin(searchName: coinName)
        }
        .bind(to: searchResult)
        .disposed(by: disposeBag)
    }
}
