//
//  SheetProfileViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class SheetProfileViewController: UIViewController {
    private lazy var successButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(successButtonTapped))
    private lazy var cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonTapped))
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let db = Database.shared
    
    var dismissClosure: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit {
        print(self, #function)
    }
    
}

//MARK: - Configure UI
extension SheetProfileViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(spacingView)
        self.view.addSubview(descriptionLabel)
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
        
    }
    
    private func configureView() {
        self.setNavigation("프로필 설정")
        self.view.backgroundColor = .black
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = successButton
        
        profileButton.addTarget(self, action: #selector(profilebuttonTapped), for: .touchUpInside)
        
        nameTextField.delegate = self
        nameTextField.textColor = .darkGray
        nameTextField.textAlignment = .left
        nameTextField.text = "닉네임을 설정해 주세요"
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingView.backgroundColor = .white
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
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
extension SheetProfileViewController {
    
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
    private func cancelButtonTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    @objc
    private func successButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        if let nicknameLabel = nameTextField.text, let descriptionLabel = descriptionLabel.text,
           descriptionLabel == NickName.NickNameType.success.rawValue {
            db.isUser = true
            db.userInfo = [nicknameLabel, .checkProfileImage(profileButton.profileImage.image), "0", .currentDate]
            self.dismissClosure?()
            self.dismiss(animated: true)
        } else {
            self.customAlert("설정 실패!", "설정 사항을 다시 확인해 주세요!", [.ok]) { }
        }
    }
}

//MARK: - TextField
extension SheetProfileViewController: UITextFieldDelegate {
    
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
