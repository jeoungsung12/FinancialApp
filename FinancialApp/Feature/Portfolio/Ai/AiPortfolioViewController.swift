//
//  AiPortfolioViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/31/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

final class AiPortfolioViewController: UIViewController {
    private let viewModel = AiPortfolioViewModel()
    private var disposeBag = DisposeBag()
    private let inputTrigger = PublishSubject<[PortfolioModel]>()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    
    var potfolioData: [PortfolioModel]?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "📊 AI 포트폴리오 분석"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBinding()
        
        inputTrigger.onNext(potfolioData!)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .black
        textView.textColor = .lightGray
        textView.font = .boldSystemFont(ofSize: 16)
        
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(loadingIndicator)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setBinding() {
        let input = AiPortfolioViewModel.Input(portfolio: inputTrigger.asObservable())
        let output = viewModel.transform(input: input)
        loadingIndicator.startAnimating()
        output.aiPrediction
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] prediction in
                guard let self = self else { return }
                self.textView.text = prediction
                loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
}
