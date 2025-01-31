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
    private var piechartHostingViewController: ProfileHostingViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy() {
        self.addSubview(totalAssetLabel)
        self.addSubview(totalInvestmentLabel)
        self.addSubview(totalReturnLabel)
        if let piechartHostingViewController = piechartHostingViewController {
            piechartHostingViewController.view.backgroundColor = .clear
            self.addSubview(piechartHostingViewController.view)
        }
        configureLayout()
    }
    
    private func configureLayout() {
        
        totalAssetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
        }
        
        totalInvestmentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAssetLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
        
        totalReturnLabel.snp.makeConstraints { make in
            make.top.equalTo(totalInvestmentLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        piechartHostingViewController?.view.snp.makeConstraints({ make in
            make.height.equalTo(200)
            make.verticalEdges.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(totalInvestmentLabel.snp.trailing).offset(12)
        })
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .darkGray.withAlphaComponent(0.4)
        
        totalAssetLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalReturnLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalInvestmentLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
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
        
        totalAssetLabel.attributedText = makeAttributedText(title: "총 자산", value: totalAsset.formatted())
        totalInvestmentLabel.attributedText = makeAttributedText(title: "총 투자금", value: totalInvestment.formatted())
        
        let returnColor: UIColor = (totalReturn >= 0) ? .systemGreen : .lightGray
        let returnText = String(format: "%.2f%%", totalReturn)
        totalReturnLabel.attributedText = makeAttributedText(title: "현재가 수익률", value: returnText, color: returnColor)
        
        piechartHostingViewController?.view.removeFromSuperview()
        piechartHostingViewController = ProfileHostingViewController(rootView: PieChartView(chartData: data.map { $0.pieModel }))
        configureView()
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
