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
        let aiPrediction: Observable<Result<String,NetworkError.CustomError>>
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
                return AiService().requestChat(search: "코인 분석", info: summary)
                    .map { (result: Result<ChatServiceModel, NetworkError.CustomError>) -> Result<String,NetworkError.CustomError> in
                        switch result {
                        case let .success(data):
                            return .success(data.choices.first?.message.content ?? "분석 결과 없음")
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
            }
        
        return Output(aiPrediction: aiPrediction)
    }
    
}
