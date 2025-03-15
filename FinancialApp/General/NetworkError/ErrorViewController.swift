//
//  NetworkErrorView.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/8/25.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

final class ErrorViewController: BaseViewController {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lineView = UIView()
    private let reloadBtn = UIButton()
    
    private let viewModel: ErrorViewModel
    private var disposeBag = DisposeBag()
    private var errorType: Error
    init(viewModel: ErrorViewModel, errorType: Error) {
        self.viewModel = viewModel
        self.errorType = errorType
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        let input = ErrorViewModel.Input(
            reloadTrigger: reloadBtn.rx.tap
        )
        let output = viewModel.transform(input)
        
        output.networkReloadTrigger
            .drive(with: self) { owner, type in
                switch type {
                case .network:
                    owner.view.makeToast(ErrorSenderType.network.rawValue, duration: 1, position: .center)
                default:
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        containerView.backgroundColor = .white
        titleLabel.text = "안내"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black
        
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
        
        [titleLabel, descriptionLabel].forEach {
            $0.textAlignment = .center
        }
        
        lineView.backgroundColor = .gray
        
        reloadBtn.setTitle("다시 시도하기", for: .normal)
        reloadBtn.setTitleColor(.gray, for: .normal)
        reloadBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    
    override func configureHierarchy() {
        [titleLabel, descriptionLabel, reloadBtn, lineView].forEach {
            self.containerView.addSubview($0)
        }
        self.view.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(lineView.snp.top).inset(12)
        }
        
        reloadBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(lineView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(12)
        }
        
    }
    
    deinit {
        print(#function, self)
    }
    
}
