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
    private let heartButton = UIButton()
    private let pageLabel = UILabel()
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
    
    func configure(_ title: String, _ row: Int,_ open_price: String ,_ highModel: [Double],_ lowModel: [Double]) {
        titleLabel.text = title
        pageLabel.text = "  \(row)/6  "
        descriptionLabel.text = "시가 \(open_price)₩"
        chartHostingViewController?.view.removeFromSuperview()
        chartHostingViewController = ChartHostingViewController(rootView: ChartView(chartData: [highModel, lowModel]))
        configureView()
    }
       
}

extension DetailChartView {
    
    private func configureHierachy() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(heartButton)
        self.addSubview(pageLabel)
        if let chartHostingViewController = chartHostingViewController {
            self.addSubview(chartHostingViewController.view)
        }
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.bottom.equalToSuperview().inset(24)
        }
        
        chartHostingViewController?.view.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        heartButton.tintColor = .white
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        checkTapped()
        
        pageLabel.textColor = .white
        pageLabel.clipsToBounds = true
        pageLabel.backgroundColor = .gray
        pageLabel.textAlignment = .left
        pageLabel.layer.cornerRadius = 5
        pageLabel.font = .boldSystemFont(ofSize: 10)
        
        configureHierachy()
    }
    
    private func checkTapped() {
        guard let text = titleLabel.text else { return }
        let data = Database.shared.getData().map { $0.market }
        selectedType = data.contains(text) ? true : false
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        selectedType.toggle()
        guard let text = titleLabel.text else { return }
        if selectedType {
            Database.shared.setData(text)
        } else {
            Database.shared.deleteData(text)
        }
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
    }
}
