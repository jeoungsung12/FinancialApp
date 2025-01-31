//
//  ProfileViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let successButton = UIButton()
    private let db = Database.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit {
        print(self, #function)
    }
    
}

//MARK: - Configure UI
extension ProfileViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(spacingView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(successButton)
        self.view.addGestureRecognizer(tapGesture)
        
        configureLayout()
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(profileButton.snp.bottom).offset(24)
        }
        
        spacingView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(spacingView.snp.bottom).offset(16)
        }
        
        successButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
        }
    }
    
    private func configureView() {
        self.setNavigation("프로필 설정")
        self.view.backgroundColor = .black
        
        nameTextField.delegate = self
        nameTextField.textAlignment = .left
        nameTextField.text = "닉네임을 설정해 주세요"
        nameTextField.textColor = .darkGray
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingView.backgroundColor = .white
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        successButton.setBorder()
        successButton.setTitle("완료", for: .normal)
        successButton.setTitleColor(.white, for: .normal)
        successButton.addTarget(self, action: #selector(successButtonTapped), for: .touchUpInside)
        
        profileButton.addTarget(self, action: #selector(profilebuttonTapped), for: .touchUpInside)
        
        configureProfileView()
        configureHierarchy()
    }
    
    private func configureProfileView() {
        let userInfo = db.userInfo
        if let text = nameTextField.text, !userInfo.isEmpty {
            nameTextField.text = userInfo[0]
            profileButton.profileImage.image = UIImage(named: userInfo[1])
            descriptionLabel.text = NickName().checkNickName(text).rawValue
        } else {
            guard let image = ProfileData.allCases.randomElement()?.rawValue else { return }
            profileButton.profileImage.image = UIImage(named: image)
        }
    }
    
}

//MARK: - Action
extension ProfileViewController {
    
    @objc
    private func profilebuttonTapped(_ sender: UIButton) {
        print(#function)
        let vc = ProfileImageViewController()
        vc.profileImage = profileButton.profileImage.image
        vc.returnImage = { [weak self] value in
            guard let self = self else { return }
            self.profileButton.profileImage.image = value
        }
        self.push(vc)
    }
    
    @objc
    private func successButtonTapped(_ sender: UIButton) {
        print(#function)
        if let nicknameLabel = nameTextField.text, let descriptionLabel = descriptionLabel.text,
           descriptionLabel == NickName.NickNameType.success.rawValue {
            db.isUser = true
            db.userInfo = [nicknameLabel, .checkProfileImage(profileButton.profileImage.image), "0", .currentDate]
            let rootVC = TabBarController()
            self.setRootView(rootVC)
        } else {
            self.customAlert("설정 실패!", "설정 사항을 다시 확인해 주세요!", [.ok]) { }
        }
    }
}

//MARK: - TextField
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.textColor = ((text.isEmpty)) ? .darkGray : .white
        textField.text = ((text.isEmpty)) ? "닉네임을 설정해 주세요" : text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        descriptionLabel.text = NickName().checkNickName(text).rawValue
    }
    
}
