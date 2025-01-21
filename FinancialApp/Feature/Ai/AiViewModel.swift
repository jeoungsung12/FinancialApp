//
//  AiViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa

class AiViewModel {
//    private let disposeBag = DisposeBag()
//    let inputTrigger = PublishSubject<Void>()
//    let outputResult : PublishSubject<[GetAllCoinModel]> = PublishSubject()
//    
//    let WMTrigger = PublishSubject<[String]>()
//    let WMResult : PublishSubject<[CandleWMModel]> = PublishSubject()
//    
//    let newsTrigger = PublishSubject<String>()
//    let newsResult: PublishSubject<[NewsItems]> = PublishSubject()
//    
//    let chatTrigger = PublishSubject<ChatModel>()
//    let chatResult : PublishSubject<ChatServiceModel> = PublishSubject()
//    
//    init() {
//        //MARK: - GetCoinInfo
//        inputTrigger
//            .flatMapLatest { _ in
//                return GetNameService.getAllCoin()
//            }
//            .bind(to: outputResult)
//            .disposed(by: disposeBag)
//        
//        WMTrigger.flatMapLatest { requestInfo in
//            return CandleService.WMCandle(market: requestInfo[0], method: requestInfo[1])
//        }
//        .bind(to: WMResult)
//        .disposed(by: disposeBag)
//        
//        newsTrigger.flatMapLatest { news in
//            return NewsService.getNews(query: news, start: 1)
//        }
//        .bind(to: newsResult)
//        .disposed(by: disposeBag)
//        
//        self.chatTrigger.flatMapLatest { chat in
//            return ChatGPTService.requestChat(searchTitle: chat)
//        }
//        .bind(to: self.chatResult)
//        .disposed(by: self.disposeBag)
//    }
}
