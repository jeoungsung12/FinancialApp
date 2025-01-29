//
//  PortfolioViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import NVActivityIndicatorView

final class PortfolioViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let db = Database.shared
    private let portfolioViewModel = PortfolioViewModel()
    private let inputTrigger = PublishSubject<[HeartItem]>()
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    private let tableView = UITableView()
    private let summaryView = PortfolioSummaryView()
    
    private var portfolioData: [PortfolioModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.onNext((db.heartList))
    }
}

// MARK: - UI 설정
extension PortfolioViewController {
    
    private func configureView() {
        self.view.backgroundColor = .black
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(summaryView)
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        summaryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setBinding()
    }
}

// MARK: - ViewModel 바인딩
extension PortfolioViewController {
    
    private func setBinding() {
        let input = PortfolioViewModel.Input(portfolioInput: inputTrigger.asObserver())
        let output = portfolioViewModel.transform(input: input)
        loadingIndicator.startAnimating()
        output.portfolioOutput
            .bind { data in
                self.portfolioData = data
                self.summaryView.configure(data: data)
                self.loadingIndicator.stopAnimating()
                self.configureTableView()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Delegate & DataSource
extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(PortfolioTableViewCell.self, forCellReuseIdentifier: PortfolioTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolioData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioTableViewCell.id, for: indexPath) as? PortfolioTableViewCell else {
            return UITableViewCell()
        }
        
        let data = portfolioData[indexPath.row]
        cell.configure(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
