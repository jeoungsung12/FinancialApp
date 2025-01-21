//
//  TotalSearchViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/23.
//

import RxSwift
import RxCocoa
import Foundation

class TotalSearchViewModel {
    private let disposeBag = DisposeBag()
    
    //검색
    let searchInputrigger = PublishSubject<String>()
    let searchResult : PublishSubject<Result<SearchResult,Error>> = PublishSubject()
    
    //환율 정보
    let inputTrigger = PublishSubject<Void>()
    let outputResult : PublishSubject<Result<FinancialResult,Error>> = PublishSubject()
    
    //코인 정보
    let coinTrigger = PublishSubject<Void>()
    let coinResult : PublishSubject<[GetAllCoinModel]> = PublishSubject()
    
    init() {
        //MARK: - coinData
        coinTrigger.flatMapLatest { _ in
            return GetNameService.getAllCoin()
        }
        .bind(to: coinResult)
        .disposed(by: self.disposeBag)
        
//        inputTrigger
//            .flatMapLatest { _ in
//                return Observable.combineLatest(FinancialNetwork.getAP01(), FinancialNetwork.getAP02()) { financialData, loadData -> Result<FinancialResult,Error> in
//                    return .success(FinancialResult( financialData: financialData, loanData: loadData))
//                }.catch { error in
//                    return Observable.just(.failure(error))
//                }
//            }
//            .bind(to: outputResult)
//            .disposed(by: disposeBag)
        
        
        //MARK: - SearchCoinInfo
//        searchInputrigger.flatMapLatest { coinName in
//            return Observable.combineLatest(SearchCoin.searchCoin(searchName: coinName), SearchOrder.searchCoin(searchName: coinName)) { coinData, orderData -> Result<SearchResult, Error> in
//                return .success(SearchResult(coinData: coinData, orderData: orderData))
//            }.catch { error in
//                return Observable.just(.failure(error))
//            }
//        }
//        .bind(to: searchResult)
//        .disposed(by: disposeBag)
    }
}
