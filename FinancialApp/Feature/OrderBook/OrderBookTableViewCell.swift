//
//  OrderBookTableViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import Charts
import DGCharts
class OrderBookTableViewCell : UITableViewCell {
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //코인 이름
    private let titleLabel : UITextField = {
        let label = UITextField()
        label.isEnabled = false
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    //거래량 총액
    private let availLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .white
        return label
    }()
    //코인 가격
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.borderWidth = 1
        return label
    }()
    //코인 상승세
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
//MARK: - UI Layout
extension OrderBookTableViewCell {
    private func setupUI() {
        let contentView = self.contentView
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        totalView.addSubview(titleLabel)
        totalView.addSubview(availLabel)
        totalView.addSubview(price)
        totalView.addSubview(arrow)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        availLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        contentView.addSubview(totalView)
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    func configure(with model: [AddTradesModel]) {
        let name = model.compactMap{ $0.coinName }.first ?? ""
        let market = model.compactMap{ $0.tradesData.market }.first ?? ""
        let price = model.compactMap{ $0.tradesData.trade_price }.first ?? 0
        let ask_bid = model.compactMap{ $0.tradesData.ask_bid }.first ?? ""
        let volume = model.compactMap{ $0.tradesData.trade_volume }.first ?? 0
        self.titleLabel.text = "\(name) \(market)"
        self.price.text = String(price)
        if ask_bid == "ASK" {
            self.price.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.white.cgColor
            }
            self.arrow.text = "📈매수"
            self.arrow.textColor = .red
        }else {
            self.price.layer.borderColor = UIColor.blue.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.white.cgColor
            }
            self.arrow.text = "📉매도"
            self.arrow.textColor = .blue
        }
        availLabel.text = "\(volume)"
    }
}
