//
//  PortfolioSummaryView.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit

final class PortfolioSummaryView: UIView {
    
    private let totalAssetLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let totalReturnLabel = UILabel()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy() {
        blurEffectView.contentView.addSubview(totalAssetLabel)
        blurEffectView.contentView.addSubview(totalInvestmentLabel)
        blurEffectView.contentView.addSubview(totalReturnLabel)
        self.addSubview(blurEffectView)
        
        configureLayout()
    }
    
    private func configureLayout() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        totalAssetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        totalInvestmentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAssetLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        totalReturnLabel.snp.makeConstraints { make in
            make.top.equalTo(totalInvestmentLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .clear
        
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.layer.masksToBounds = true
        
        totalAssetLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalReturnLabel.font = UIFont.boldSystemFont(ofSize: 15)
        totalInvestmentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        totalAssetLabel.textColor = .white
        totalReturnLabel.textColor = .white
        totalInvestmentLabel.textColor = .white
        
        totalAssetLabel.textAlignment = .left
        totalReturnLabel.textAlignment = .left
        totalInvestmentLabel.textAlignment = .left
        
        configureHierarchy()
    }
    
    func configure(data: [PortfolioModel]) {
        let totalAsset = data.reduce(0) { $0 + ($1.currentPrice * $1.quantity) }
        let totalInvestment = data.reduce(0) { $0 + ($1.purchasePrice * $1.quantity) }
        let totalReturn = ((totalAsset - totalInvestment) / totalInvestment) * 100
        
        totalAssetLabel.attributedText = makeAttributedText(title: "총 자산", value: totalAsset)
        totalInvestmentLabel.attributedText = makeAttributedText(title: "총 투자금", value: totalInvestment)
        
        let returnColor: UIColor = (totalReturn >= 0) ? .systemGreen : .lightGray
        let returnText = String(format: "%.2f%%", totalReturn)
        totalReturnLabel.attributedText = makeAttributedText(title: "수익률", value: returnText, color: returnColor)
    }
    
    private func makeAttributedText(title: String, value: Any, color: UIColor = .white) -> NSAttributedString {
        let titleAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let valueAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
                         NSAttributedString.Key.foregroundColor: color]
        
        let attrString = NSMutableAttributedString(string: "\(title): ", attributes: titleAttr)
        attrString.append(NSAttributedString(string: "\(value)", attributes: valueAttr))
        
        return attrString
    }
}
