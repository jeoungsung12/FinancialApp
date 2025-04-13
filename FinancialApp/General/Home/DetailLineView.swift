//
//  DetailLineView.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import UIKit
import SnapKit

final class DetailLineView: BaseView {
    private var chartHostingViewController: LineHostingViewController?
    func configure(_ model: [CandleModel]) {
        chartHostingViewController?.view.removeFromSuperview()
        chartHostingViewController = LineHostingViewController(rootView: LineChartView(chartData: model))
        configureView()
    }
    
    override func configureHierarchy() {
        if let chartHostingViewController = chartHostingViewController {
            self.addSubview(chartHostingViewController.view)
        }
        configureLayout()
    }
    
    override func configureLayout() {
        chartHostingViewController?.view.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        configureHierarchy()
    }
       
}
