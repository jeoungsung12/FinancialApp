//
//  FinancialNetwork.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/24.
//

import SnapKit
import RxSwift
import RxCocoa
import Alamofire
import Foundation

final class FinancialNetwork {
    //TODO: - 리팩
    func getExchange() -> Observable<[FinancialModel]> {
        let currentDate = UserDefinedFunction.shared.getCurrentDate()
        let url : String = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP01"
        return NetworkManager.shared.getData(url, headers: nil)
            .flatMap { (response: [FinancialModel]) -> Observable<[FinancialModel]> in
                let result = response.filter({ $0.cur_nm == "미국 달러" })
                return Observable.just(result)
            }
    }
    
    func getLoan() -> Observable<[LoanModel]> {
        let currentDate = UserDefinedFunction.shared.getCurrentDate()
        let url : String = "https://www.koreaexim.go.kr/site/program/financial/interestJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP02"
        return NetworkManager.shared.getData(url, headers: nil)
            .flatMap { (response: [LoanModel]) -> Observable<[LoanModel]> in
                let result = response.filter { $0.sfln_intrc_nm == "수은채 유통수익률 1개월" }
                return Observable.just(result)
            }
    }
    
    func getInternational() -> Observable<[InternationalModel]> {
        let currentDate = UserDefinedFunction.shared.getCurrentDate()
        let url : String = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP03"
        return NetworkManager.shared.getData(url, headers: nil)
            .flatMap { (response: [InternationalModel]) -> Observable<[InternationalModel]> in
                return Observable.just(response)
            }
    }
}
