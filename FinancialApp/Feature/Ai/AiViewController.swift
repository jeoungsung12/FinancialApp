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
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    
    private let trendLabel = UILabel()
    private let confidenceLabel = UILabel()
    private let progressView = UIProgressView()
    private let textView = UITextView()
    
    var coinData: CoinDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension AiViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(trendLabel)
        self.view.addSubview(confidenceLabel)
        self.view.addSubview(progressView)
        self.view.addSubview(textView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        
        trendLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        confidenceLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(trendLabel.snp.bottom).offset(12)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(confidenceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setBinding()
        inputTrigger.onNext(coinData!)
    }
    
    private func configureView() {
        view.backgroundColor = .black
        trendLabel.font = .boldSystemFont(ofSize: 20)
        trendLabel.textAlignment = .center
        
        confidenceLabel.font = .systemFont(ofSize: 16)
        confidenceLabel.textAlignment = .center
        
        progressView.trackTintColor = .lightGray
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .black
        textView.textColor = .lightGray
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] resultText in
                self?.updateUI(with: resultText)
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with result: String) {
        let trend: String
        let confidence: Float
        let color: UIColor
        
        if result.contains("상승") {
            trend = "📈 상승 추세"
            confidence = extractConfidence(from: result) / 100
            color = .systemGreen
        } else if result.contains("하락") {
            trend = "📉 하락 추세"
            confidence = extractConfidence(from: result) / 100
            color = .systemRed
        } else {
            trend = "🔄 보합"
            confidence = 0.5
            color = .systemGray
        }
        
        trendLabel.text = trend
        trendLabel.textColor = color
        confidenceLabel.text = "가능성: \(Int(confidence * 100))%"
        progressView.progress = confidence
        progressView.progressTintColor = color
        textView.text = result
    }
    
    private func extractConfidence(from text: String) -> Float {
        let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Float($0) }
        return numbers.first ?? 50
    }
}

