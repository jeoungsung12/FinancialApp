//
//  ErrorViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 2/3/25.
//

import UIKit
import SnapKit
import Lottie

final class ErrorViewController: UIViewController {
    private lazy var dismissBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
    private let imageView = LottieAnimationView(name: "lottie")
    private let titleLabel = UILabel()
    private let descriptioinLabel = UILabel()
    
    init(_ message: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension ErrorViewController {
    
    private func configureHierarchy() {
        self.navigationItem.leftBarButtonItem = dismissBarButton
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptioinLabel)
        self.view.addSubview(imageView)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptioinLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.top.equalTo(descriptioinLabel.snp.bottom).offset(12)
        }
        
    }
    
    private func configureView() {
        self.view.backgroundColor = .black
        
        dismissBarButton.tintColor = .white
        
        imageView.loopMode = .loop
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.play()
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemOrange
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        descriptioinLabel.textColor = .lightGray
        descriptioinLabel.textAlignment = .center
        descriptioinLabel.text = "잠시 후 다시 시도해주세요"
        descriptioinLabel.font = .boldSystemFont(ofSize: 15)
        
        
        configureHierarchy()
    }
}

extension ErrorViewController {
    
    @objc
    private func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}
