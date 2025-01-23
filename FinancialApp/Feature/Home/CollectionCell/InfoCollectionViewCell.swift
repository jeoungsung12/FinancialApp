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
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
            make.leading.trailing.equalToSuperview().inset(8)
        }
        decLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-6)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(decLabel.snp.bottom).offset(4)
            make.trailing.leading.equalToSuperview().inset(8)
        }
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .systemGray5.withAlphaComponent(0.5)
        configureHierarchy()
    }
}

extension InfoCollectionViewCell {
    
    func configure(model: InfoDataModel, index: Int) {
        if index == 0 {
            titleLabel.text = "\(model.title)%"
            let type = KoreanGreed.neutral.catchText(model.subTitle)
            decLabel.text = type.returnText
            dateLabel.text = "공포탐욕지수"
        } else if index == 1 {
            dateLabel.text = "고정 기준 금리"
            self.decLabel.text = model.description
            self.titleLabel.text = model.title
        } else if index == 2 {
            self.titleLabel.text = model.title
            self.decLabel.text = model.subTitle
            self.dateLabel.text = model.description
        }
    }
}
