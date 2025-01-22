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
    private var chartData: [[CandleModel]] = []
    private var chartNum: Int = 0
    
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
    
    func configure(_ model: [[CandleModel]],_ row: Int) {
        self.chartData = model
        let model = model[chartNum]
        let highPrices = model.compactMap { $0.high_price }
        let lowPrices = model.compactMap { $0.low_price }
        let scale = UserDefinedFunction.shared.setScaleChart(highPrices: highPrices, lowPrices: lowPrices)
        chartView.configure(model[0].market, row, model[0].opening_price.formatted(), scale[0], scale[1])
    }
    
}
