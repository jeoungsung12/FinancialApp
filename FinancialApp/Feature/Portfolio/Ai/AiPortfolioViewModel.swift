//
//  AiPortfolioViewModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/31/25.
//
import Foundation
import RxSwift
import RxCocoa

final class AiPortfolioViewModel {
    
    struct Input {
        let portfolio: Observable<[PortfolioModel]>
    }
    
    struct Output {
        let news: Observable<[NewsItems]>
        let chartData: Observable<[[CandleModel]]>
        let orderBook: Observable<[[AddTradesModel]]>
        let aiPrediction: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let news = input.portfolio
            .flatMapLatest { data in
                NewsService().getNews(query: data.map { $0.name }.joined(separator: ", ") , display: 5)
            }
        
        let chartData = input.portfolio
            .flatMapLatest { data in
                CandleService().getCandleList(markets: cryptoData.filter({data.map({$0.name}).contains($0.korean_name)}).map{$0.market}, method: .months)
            }
        
        let orderBook = input.portfolio
            .flatMapLatest { data in
                OrderBookService().getTotal(totalData: cryptoData.filter({data.map({$0.name}).contains($0.korean_name)}))
            }
        
        let aiPrediction = Observable.zip(news, chartData, orderBook)
            .flatMapLatest { news, chart, orderBook in
                let summary = """
                    다음은 소유하고 있는 코인에 대한 정보입니다:
                    - 최근 뉴스: \(news)
                    - 1년 캔들 차트 데이터: \(chartData)
                    - 호가 정보: \(orderBook)
                    
                    \(ModelTuning.TuningType.portfolio.message)
                    """
                return AiService().requestChat(search: "소유한 암호화폐 분석", info: summary)
                    .map { $0.choices.first?.message.content ?? "분석 실패" }
            }
        
        return Output(news: news, chartData: chartData, orderBook: orderBook, aiPrediction: aiPrediction)
    }
    
}
