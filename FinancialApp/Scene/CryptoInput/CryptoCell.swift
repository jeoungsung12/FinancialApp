//
//  CryptoCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//
import UIKit
import Kingfisher
import SnapKit

final class CryptoCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let icon = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(_ model: CryptoModel) {
        titleLabel.text = model.korean_name
        if let text = model.english_name.first {
            icon.text = String(text)
        }
    }
}

extension CryptoCell {
    
    private func configureHierarchy() {
        self.addSubview(icon)
        self.addSubview(titleLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        icon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(icon.snp.trailing).offset(12)
        }
    }
    
    private func configureView() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .darkGray
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        icon.textColor = .white
        icon.clipsToBounds = true
        icon.textAlignment = .center
        icon.layer.cornerRadius = 20
        icon.backgroundColor = .randomColor()
        icon.font = .systemFont(ofSize: 20, weight: .heavy)
        configureHierarchy()
    }
}
