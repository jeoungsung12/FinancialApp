//
//  DetailAiViewModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import RxSwift
import RxSwift
import RxCocoa

final class AiViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let coinDetail: Observable<CoinDetailModel>
    }
    
    struct Output {
        let aiPrediction: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let aiPrediction = input.coinDetail
            .flatMapLatest { coinDetail in
                let name = coinDetail.ticksData[0].map({$0.coinName})
                let prompt = """
                다음은 \(name) 코인에 대한 정보입니다:
                - 최근 뉴스: \(coinDetail.newsData.map { $0.title }.joined(separator: ", "))
                - 1년 캔들 차트 데이터: \(coinDetail.chartData)
                - 현재 호가 데이터: \(coinDetail.ticksData)
                
                \(ModelTuning.TuningType.detail.message)
                """
                
                return AiService().requestChat(search: "코인 분석", info: prompt)
                    .map { $0.choices.first?.message.content ?? "분석 결과 없음" }
            }
        
        return Output(aiPrediction: aiPrediction)
    }
}
