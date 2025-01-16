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
    //환율
    static func getAP01() -> Observable<[FinancialModel]> {
        return Observable.create { observer in
            let currentDate = getCurrentDate()
            let url : String = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP01"
            AF.request(url, method: .get, headers: ["Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: [FinancialModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //대출금리
    static func getAP02() -> Observable<[LoanModel]> {
        return Observable.create { observer in
            let currentDate = getCurrentDate()
            let url : String = "https://www.koreaexim.go.kr/site/program/financial/interestJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP02"
            AF.request(url, method: .get, headers: ["Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: [LoanModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //국제금리
    static func getAP03() -> Observable<[InternationalModel]> {
        return Observable.create { observer in
            let currentDate = getCurrentDate()
            let url : String = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=\(Bundle.main.FinancialKey)&searchdate=\(currentDate)&data=AP03"
            AF.request(url, method: .get, headers: ["Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: [InternationalModel].self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    static func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식
        return dateFormatter.string(from: date)
    }
}
