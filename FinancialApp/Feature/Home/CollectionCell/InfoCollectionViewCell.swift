//
//  InfoCollectionViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/21/25.
//

import UIKit
import SnapKit

final class InfoCollectionViewCell : UICollectionViewCell {
    static let id = "InfoCollectionViewCell"
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let decLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .lightGray
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension InfoCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(decLabel)
        self.addSubview(dateLabel)
        
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        decLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(decLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(4)
        }
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .systemGray4
        configureHierarchy()
    }
}
//MARK: - Action
extension InfoCollectionViewCell {
    
    func configure(model: Any) {
        if let model = model as? GreedModel,
           let data = model.data.first {
            let Icon = (data.value_classification.contains("Greed")) ? "😲" : "😈"
            titleLabel.text = "\(data.value)%\(Icon)"
            decLabel.text = "공포탐욕지수"
        }
        
        if let model = model as? [LoanModel],
           let date = model.first?.sfln_intrc_nm,
           let loan_int = model.first?.int_r {
            dateLabel.text = "고정 기준 금리"
            self.decLabel.text = "\(date)"
            self.titleLabel.text = "📊 \(loan_int) %"
        }
        
        
        if let model = model as? [InternationalModel] {
            print(model)
        }
        
        if let model = model as? [FinancialModel],
           let name = model.first?.cur_nm, let unit = model.first?.cur_unit,
           let ttb = model.first?.ttb, let tts = model.first?.tts, let deal = model.first?.deal_bas_r {
            self.decLabel.text = "\(name) \(unit)"
            self.titleLabel.text = "📥\(ttb)₩\n📤\(tts)₩"
            self.dateLabel.text = "매매 기준율 : \(deal)₩"
            
        }
    }
}
