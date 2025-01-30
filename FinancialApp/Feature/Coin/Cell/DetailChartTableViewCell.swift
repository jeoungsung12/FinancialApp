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
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    
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
    
    func configure(_ candleModel: [CandleModel],_ ticksModel: AddTradesModel) {
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
    }
    
}

extension DetailChartTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(chartView)
        self.addSubview(price)
        self.addSubview(arrow)
        configureLayout()
    }
    
    private func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.horizontalEdges.equalToSuperview()
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(chartView.snp.bottom).offset(36)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
    }
    
    private func configureView() {
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
}
