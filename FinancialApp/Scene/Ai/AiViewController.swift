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
    
    private let loadingIndicator = NVActivityIndicatorView(
        frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)),
        type: .ballPulseSync,
        color: .white
    )
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let resultLabel = UILabel()
    
    var coinData: CoinDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        rewardHelper.loadRewardedAd()
    }
}

extension AiViewController {
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        [imageView, resultLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        configureLayout()
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo((UIScreen.main.bounds.width - 24) * 0.65)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(100)
        }
        
        setBinding()
        inputTrigger.onNext(coinData!)
    }
    
    private func configureView() {
        view.backgroundColor = .black
        
        scrollView.showsVerticalScrollIndicator = false
        
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        resultLabel.numberOfLines = 0
        resultLabel.textColor = .lightGray
        resultLabel.backgroundColor = .black
        resultLabel.font = .boldSystemFont(ofSize: 16)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        
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
                case let .success(data):
                    self.resultLabel.text = data[0]
                    self.imageView.image = UIImage(named: data[1])
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

