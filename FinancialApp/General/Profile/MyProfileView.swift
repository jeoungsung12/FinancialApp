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
    private let arrow = UIButton()
    private let saveButton = UIButton()
    private let userInfo = Database.shared.getUser()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ userInfo: UserInfo) {
        dateLabel.text = userInfo.date
        nameLabel.text = userInfo.nickname
        profileImage.profileImage.image = userInfo.profile
        saveButton.setTitle("\(userInfo.coinCount) 개의 가상화폐 보관중", for: .normal)
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        self.addSubview(profileImage)
        self.addSubview(arrow)
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
        
        arrow.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalTo(arrow.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(arrow.snp.leading).offset(-4)
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
        self.backgroundColor = .darkGray
        
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
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        arrow.isEnabled = false
        arrow.tintColor = .lightGray
        arrow.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        
        configureHierarchy()
    }
}
