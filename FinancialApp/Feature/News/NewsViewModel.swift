//
//  NewsViewModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//
import Foundation
import RxCocoa
import RxSwift

class NewsViewModel {
    private let disposeBag = DisposeBag()
    let inputTrigger = PublishSubject<String>()
    let MainTable: BehaviorRelay<[NewsItems]> = BehaviorRelay(value: [])
    
    //페이징 변수
    private let initialLoadStart = 1
    private var currentPage = 1
    
    init() {
        inputTrigger
            .subscribe { query in
                NewsService.getNews(query: query, start: 1)
                    .map { coinData -> [NewsItems] in
                        return coinData
                    }
                    .bind(to: self.MainTable)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    func loadMoreData(query: String, completion: @escaping () -> Void) {
        currentPage += 1
        NewsService.getNews(query: query, start: currentPage)
            .map { coinData -> [NewsItems] in
                return coinData
            }
            .subscribe(onNext: { [weak self] newData in
                guard let self = self else { return }
                var currentData = self.MainTable.value
                currentData.append(contentsOf: newData)
                self.MainTable.accept(currentData)
                completion()
            })
            .disposed(by: disposeBag)
    }
}
