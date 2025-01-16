//
//  InternationalCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/27.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class SearchCollectionViewCell : UICollectionViewCell {
    static let id : String = "SearchCollectionViewCell"
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
private extension SearchCollectionViewCell {
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
extension SearchCollectionViewCell {
    public func configure(with model: SearchResult) {
        let data = model.coinData.compactMap { $0.coinData }
        let coinName = model.coinData.compactMap{ $0.coinName } //코인 이름
        let coinMarket = model.coinData.compactMap { $0.coinData.market } //코인 마켓
        let change = model.coinData.compactMap{ $0.coinData.change }//코인 상/하/보합
        
        self.titleLabel.text = "\(coinName.first ?? "") \(coinMarket.first ?? "")"
        self.availLabel.text = data.compactMap { $0.trade_date }.first
        self.price.text = "\(data.compactMap { $0.opening_price }.first ?? 0.0)"
        if change[0] == "EVEN"{
            arrow.textColor = .gray
            arrow.text = "보합"
        }else if change[0] == "RISE" {
            price.layer.borderColor = UIColor.systemRed.cgColor
            arrow.textColor = .systemRed
            arrow.text = "상승 📈"
        }else if change[0] == "FALL" {
            price.layer.borderColor = UIColor.systemBlue.cgColor
            arrow.textColor = .systemBlue
            arrow.text = "하락 📉"
        }
    }
}
