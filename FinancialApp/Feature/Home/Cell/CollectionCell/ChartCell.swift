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
    
    var heartTapped: ((ToastType)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = false
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
            make.height.equalToSuperview().dividedBy(1.8)
        }
    }
    
    private func configureView() {
        chartView.heartTapped = { [weak self] type in
            self?.heartTapped?(type)
        }
        configureHierarchy()
    }
}

extension ChartCell {
    
    func configure(_ model: [CandleModel]) {
        chartView.configure(model[0].market, model[0].opening_price.formatted(), model)
    }
    
}
