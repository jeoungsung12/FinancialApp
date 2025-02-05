//
//  AiViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import NVActivityIndicatorView

final class AiViewController: UIViewController {
    private let viewModel = AiViewModel()
    private var disposeBag = DisposeBag()
    private let inputTrigger = PublishSubject<CoinDetailModel>()
    private let rewardHelper = RewardedHelper()
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    private let textView = UITextView()
    
    var coinData: CoinDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        rewardHelper.loadRewardedAd()
    }
    
}

extension AiViewController {
    
    private func configureHierarchy() {
        [textView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        textView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setBinding()
        inputTrigger.onNext(coinData!)
    }
    
    private func configureView() {
        view.backgroundColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textColor = .lightGray
        textView.backgroundColor = .black
        textView.font = .boldSystemFont(ofSize: 16)
        configureHierarchy()
    }
    
}

extension AiViewController {
    
    private func setBinding() {
        let input = AiViewModel.Input(coinDetail: inputTrigger.asObservable())
        let output = viewModel.transform(input: input)
        loadingIndicator.startAnimating()
        output.aiPrediction
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(text):
                    self.textView.text = text
                    self.loadingIndicator.stopAnimating()
                    self.rewardHelper.showRewardedAd(viewController: self)
                case let .failure(error):
                    self.errorPresent(error)
                    self.loadingIndicator.stopAnimating()
                }
               
            })
            .disposed(by: disposeBag)
    }
}

