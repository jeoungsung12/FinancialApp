//
//  PortfolioTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift

final class PortfolioTableViewCell: UITableViewCell {
    static let id = "PortfolioTableViewCell"
    
    private let nameLabel = UILabel()
    private let quantityLabel = UILabel()
    private let purchasePriceLabel = UILabel()
    private let currentPriceLabel = UILabel()
    private let returnLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.backgroundColor = .clear
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        quantityLabel.font = UIFont.systemFont(ofSize: 14)
        purchasePriceLabel.font = UIFont.systemFont(ofSize: 14)
        currentPriceLabel.font = UIFont.systemFont(ofSize: 14)
        returnLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        nameLabel.textColor = .white
        quantityLabel.textColor = .white
        purchasePriceLabel.textColor = .lightGray
        currentPriceLabel.textColor = .lightGray
        returnLabel.textColor = .lightGray
        
        [nameLabel, quantityLabel, purchasePriceLabel, currentPriceLabel, returnLabel].forEach {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 2
        }
        
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, quantityLabel, purchasePriceLabel, currentPriceLabel, returnLabel])
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(_ data: PortfolioModel) {
        nameLabel.text = data.name
        quantityLabel.text = "\(data.quantity) 개"
        purchasePriceLabel.text = "매수가: \(data.purchasePrice.formatted()) 원"
        currentPriceLabel.text = "현재가: \(data.currentPrice.formatted()) 원"
        
        let profit = ((data.currentPrice - data.purchasePrice) / data.purchasePrice) * 100
        returnLabel.text = String(format: "수익률 %.2f%%", profit)
        
        returnLabel.textColor = profit > 0 ? .green : .lightGray
    }
}
