//
//  DetailChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import UIKit
import SnapKit
import Toast

enum ToastType {
    case success
    case failure
}

final class DetailChartView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let heartButton = UIButton()
    private var chartHostingViewController: ChartHostingViewController?
    
    private var selectedType: Bool = false
    private let db = Database.shared
    
    var heartTapped: ((ToastType)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ open_price: String ,_ model: [CandleModel]) {
        descriptionLabel.text = "시가 \(open_price)₩"
        selectedType = (db.heartList.contains(title)) ? true : false
        titleLabel.text = cryptoData.filter( { $0.market == title }).first?.korean_name
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
        
        chartHostingViewController?.view.removeFromSuperview()
        chartHostingViewController = ChartHostingViewController(rootView: CandleChartView(chartData: model))
        configureView()
    }
       
}

extension DetailChartView {
    
    private func configureHierachy() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(heartButton)
        if let chartHostingViewController = chartHostingViewController {
            self.addSubview(chartHostingViewController.view)
        }
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.leading.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.trailing.equalToSuperview().inset(24)
        }
        
        chartHostingViewController?.view.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
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
        configureHierachy()
    }
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let text = titleLabel.text, let market = cryptoData.filter({ $0.korean_name == text }).first?.market else { return }
        selectedType.toggle()
        if selectedType {
            db.removeHeartButton(market)
            db.heartList.append(market)
            heartTapped?(.success)
        } else {
            db.deleteData(market)
            heartTapped?(.failure)
        }
    }
}
