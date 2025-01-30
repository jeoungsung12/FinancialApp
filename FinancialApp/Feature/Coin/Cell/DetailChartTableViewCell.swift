//
//  DetailChartCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit
import Toast

final class DetailChartTableViewCell: UITableViewCell {
    static let id: String = "ChartTableViewCell"
    private let chartView = DetailChartView()
    private let price: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private let arrow: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let greedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = .darkGray.withAlphaComponent(0.4)
        return label
    }()
    private let aiButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Ai 분석 결과 보기 ➡️", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.backgroundColor = .darkGray.withAlphaComponent(0.4)
        return button
    }()
    
    var aiTapped: (()->Void)?
    var heartTapped: ((Bool, String)->Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ candleModel: [CandleModel],_ ticksModel: AddTradesModel, greed: GreedData?) {
        let price = ticksModel.tradesData.trade_price
        let ask_bid = ticksModel.tradesData.ask_bid
        chartView.configure(candleModel[0].market, candleModel[0].opening_price.formatted(), candleModel)
        
        self.price.text = "\(price.formatted())₩"
        if ask_bid == "ASK" {
            self.price.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.black.cgColor
            }
            self.arrow.text = "📈매수"
            self.arrow.textColor = .red
        }else {
            self.price.layer.borderColor = UIColor.systemGreen.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.black.cgColor
            }
            self.arrow.text = "📉매도"
            self.arrow.textColor = .systemGreen
        }
        
        guard let greed else { return }
        let greedText = KoreanGreed.greed.catchText(greed.value_classification)
        greedLabel.text = " 공포탐욕지수 \(greed.value)% \(greedText.returnText) "
    }
    
}

extension DetailChartTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(chartView)
        self.addSubview(price)
        self.addSubview(arrow)
        self.addSubview(greedLabel)
        self.addSubview(aiButton)
        configureLayout()
    }
    
    private func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.horizontalEdges.equalToSuperview()
        }
        price.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(chartView.snp.bottom).offset(36)
        }
        arrow.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        greedLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(arrow.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        aiButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(greedLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        aiButton.addTarget(self, action: #selector(aiButtonTapped), for: .touchUpInside)
        
        chartView.heartTapped = { [weak self] type in
            guard let self = self else { return }
            switch type {
            case let .add(title):
                self.heartTapped?(true, title)
            case let .remove(title):
                self.heartTapped?(false, title)
            }
        }
        configureHierarchy()
    }
    @objc private func aiButtonTapped() {
        aiTapped?()
    }
}
