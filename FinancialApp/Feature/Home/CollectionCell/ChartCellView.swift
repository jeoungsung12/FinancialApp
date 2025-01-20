//
//  ChartCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//
import UIKit
import SnapKit

final class ChartCell : UICollectionViewCell {
    static let id = "ChartCell"
    
    private let chartView = DetailChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension ChartCell {
    
    private func configureHierarchy() {
        self.addSubview(chartView)
        configureLayout()
    }
    
    private func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        configureHierarchy()
    }
}
//MARK: - Action
extension ChartCell {
    
    func configure(_ model: [CandleMinuteModel]) {
        let highPrices = model.compactMap { $0.high_price }
        let lowPrices = model.compactMap { $0.low_price }
        //TODO: - 빼내기
        let highChanges = highPrices.enumerated().map { index, value in
            guard index > 0 else { return 0.0 }
            return (value - highPrices[index - 1]) / highPrices[index - 1] * 100
        }
        
        let lowChanges = lowPrices.enumerated().map { index, value in
            guard index > 0 else { return 0.0 }
            return (value - highPrices[index - 1]) / highPrices[index - 1] * 100
        }
        
        chartView.configure(model[0].market ?? "", highChanges, lowChanges)
    }
    
}
