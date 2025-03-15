//
//  MyPageViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    private var myProfileView = MyProfileView()
    private let buttonStackView = UIStackView()
    private let db = Database.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myProfileView.configure(db.getUser(), 0)
    }
    
}

extension MyPageViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(myProfileView)
        self.view.addSubview(buttonStackView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        myProfileView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(myProfileView.snp.bottom).offset(24)
        }
        
    }
    
    private func configureView() {
        self.setNavigation("설정")
        self.view.backgroundColor = .black
        
        myProfileView.addTarget(self, action: #selector(myProfileTapped), for: .touchUpInside)
        
        buttonStackView.spacing = 15
        buttonStackView.axis = .vertical
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (type) in MyPageType.allCases {
            let button = MyPageSectionButton()
            switch type {
            case .oftenQS:
                button.addTarget(self, action: #selector(FAQTapped), for: .touchUpInside)
            case .profile:
                button.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
            case .feedback:
                button.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
            case .withdraw:
                button.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)
            }
            button.configure(type.rawValue)
            buttonStackView.addArrangedSubview(button)
        }
        
        configureHierarchy()
    }
    
}


extension MyPageViewController {
    
    @objc
    private func myProfileTapped(_ sender: UIButton) {
        print(#function)
        let vc = SheetProfileViewController()
        vc.dismissClosure = {
            self.myProfileView.configure(self.db.getUser(), 0)
        }
        self.sheet(vc)
    }
    
    @objc
    private func FAQTapped(_ sender: UIButton) {
        print(#function)
        let vc = FAQViewController()
        self.push(vc)
    }
    
    @objc
    private func profileTapped(_ sender: UIButton) {
        print(#function)
        let vc = SheetProfileViewController()
        vc.dismissClosure = {
            self.myProfileView.configure(self.db.getUser(), 0)
        }
        self.sheet(vc)
    }
    
    @objc
    private func feedbackTapped(_ sender: UIButton) {
        print(#function)
        UIApplication.shared.open(URL(string: APIEndpoint.feedback.baseURL)!)
    }
    
    @objc
    private func withdrawTapped(_ sender: UIButton) {
        print(#function)
        self.customAlert(
            "탈퇴하기",
            "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
            [.ok, .cancel]
        ) {
            self.db.removeUserInfo()
            let rootVC = UINavigationController(rootViewController: OnboardingViewController())
            self.setRootView(rootVC)
        }
    }
}
