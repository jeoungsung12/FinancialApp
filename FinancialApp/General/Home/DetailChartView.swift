//
//  DetailChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import UIKit
import SnapKit

final class DetailChartView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var chartHostingViewController: ChartHostingViewController?
    private var selectedType: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String,_ open_price: String ,_ highModel: [Double],_ lowModel: [Double]) {
        titleLabel.text = title
        descriptionLabel.text = "시가 \(open_price)₩"
        chartHostingViewController = ChartHostingViewController(rootView: ChartView(chartData: [highModel, lowModel]))
        configureView()
    }
       
}

extension DetailChartView {
    
    func configureHierachy() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        if let chartHostingViewController = chartHostingViewController {
            self.addSubview(chartHostingViewController.view)
        }
        configureLayout()
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
        }
        
        chartHostingViewController?.view.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureView() {
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        configureHierachy()
    }
}
