//
//  OrderBookCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class OrderBookCollectionViewCell : UICollectionViewCell {
    static let id : String = "OrderBookCollectionViewCell"
    //MARK: - UI Components
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
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension OrderBookCollectionViewCell {
    private func setLayout() {
        self.addSubview(titleLabel)
        self.addSubview(availLabel)
        self.addSubview(price)
        self.addSubview(arrow)
        
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
    }
}
//MARK: - Configure
extension OrderBookCollectionViewCell {
    public func configure(with model: [AddTradesModel]) {
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
