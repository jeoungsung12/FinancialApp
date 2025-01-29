//
//  MyProfileView.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class MyProfileView: UIButton {
    private let profileImage = CustomProfileButton(60, true)
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let rateLabel = UILabel()
    private let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ userInfo: UserInfo,_ rate: Double) {
        dateLabel.text = userInfo.date
        nameLabel.text = userInfo.nickname
        profileImage.profileImage.image = userInfo.profile
        saveButton.setTitle("\(userInfo.coinCount) 개의 가상화폐 보관중", for: .normal)
        rateLabel.text = (rate != 0) ? String(format: "수익률 %.2f%%", rate) : ""
        rateLabel.textColor = (rate <= 0) ? .lightGray : .systemGreen
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        self.addSubview(profileImage)
        self.addSubview(rateLabel)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(saveButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalTo(rateLabel.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(rateLabel.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.top.equalTo(profileImage.snp.bottom).offset(16)
        }
        
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        dateLabel.textColor = .lightGray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .white.withAlphaComponent(0.8)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        rateLabel.textAlignment = .right
        rateLabel.font = .boldSystemFont(ofSize: 20)
        
        configureHierarchy()
    }
}
