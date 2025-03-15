//
//  OnboardingViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit {
        print(self, #function)
    }

}

//MARK: - Configure UI
extension OnboardingViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(startButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
        }
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .black
        
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "onboarding")
        
        titleLabel.text = "Ai와 함께하는 포트폴리오"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.text = "당신만의 암호화폐 포트폴리오,\n그래빗에서 시작해보세요."
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        startButton.setBorder()
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        configureHierarchy()
    }
    
}

//MARK: - Action
extension OnboardingViewController {
    
    @objc
    private func startButtonTapped(_ sender: UIButton) {
        print(#function)
        let vc = ProfileViewController()
        self.push(vc)
    }
    
}
