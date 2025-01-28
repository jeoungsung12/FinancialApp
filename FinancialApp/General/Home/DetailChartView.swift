//
//  DetailChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import UIKit
import SnapKit
import Toast

final class DetailChartView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let heartButton = UIButton()
    private var chartHostingViewController: ChartHostingViewController?
    
    private var selectedType: Bool = false
    private let db = Database.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ open_price: String ,_ model: [CandleModel]) {
        titleLabel.text = cryptoData.filter( { $0.market == title }).first?.korean_name
        descriptionLabel.text = "시가 \(open_price)₩"
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
        checkTapped()
        configureHierachy()
    }
    
    private func checkTapped() {
        guard let text = titleLabel.text else { return }
        
        selectedType = (db.market.contains(text)) ? true : false
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        selectedType.toggle()
        guard let text = titleLabel.text else { return }
        guard let market = cryptoData.filter({ $0.korean_name == text }).first?.market else { return }
        if selectedType {
            var data = db.market
            data.append(market)
            db.market = data
            self.customMakeToast(ToastModel(title: nil, message: "찜하기 성공🎁, 목록을 확인하세요!"), HomeViewController())
        } else {
            db.deleteData(market: market)
            self.customMakeToast(ToastModel(title: nil, message: "찜하기 📭 목록에서 삭제되었습니다!"), HomeViewController())
        }
        heartButton.setImage(UIImage(systemName: selectedType ? "heart.fill" : "heart"), for: .normal)
    }
}
