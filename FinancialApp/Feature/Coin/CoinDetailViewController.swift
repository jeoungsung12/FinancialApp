//
//  CoinDetailViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class CoinDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = CoinDetailViewModel()
    private let inputTrigger = PublishSubject<CoinDetailInput>()
    
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    private let tableView = UITableView()
    private let db = Database.shared
    private var searchCoinType: CandleType = .days
    
    private var coinData: CoinDetailModel = CoinDetailModel(chartData: [], newsData: [], ticksData: [], greedIndex: nil) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var timer: Timer?
    
    var coinName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.onNext((CoinDetailInput(name: self.coinName, type: searchCoinType)))
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
}

extension CoinDetailViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(self.view.safeAreaInsets)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setBinding()
    }
    
    private func configureView() {
        self.setNavigation("")
        self.view.backgroundColor = .black
        
        configureHierarchy()
    }
}

extension CoinDetailViewController {
    
    private func setBinding() {
        loadingIndicator.startAnimating()
        let input = CoinDetailViewModel.Input(chartInput: inputTrigger.asObserver())
        let output = viewModel.transform(input: input)
        
        output.chartOutput.bind { [weak self] data in
            guard let self = self else { return }
            self.coinData = data
            self.configureTableView()
            self.loadingIndicator.stopAnimating()
        }.disposed(by: disposeBag)
    }
    
}

extension CoinDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DetailChartTableViewCell.self, forCellReuseIdentifier: DetailChartTableViewCell.id)
        tableView.register(AdsTableViewCell.self, forCellReuseIdentifier: AdsTableViewCell.id)
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CoinItems.allCases[indexPath.row] {
        case .chart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailChartTableViewCell.id, for: indexPath) as? DetailChartTableViewCell else { return UITableViewCell() }
            cell.configure(coinData.chartData[0], coinData.ticksData[0][0], greed: coinData.greedIndex?.data.first)
            //TODO: 수정
            cell.dropdownTapped = { [weak self] title in
                self?.searchCoinType = CandleType.days.returnType(title)
                self?.inputTrigger.onNext((CoinDetailInput(name: self?.coinName, type: self?.searchCoinType ?? .days)))
            }
            
            cell.heartTapped = { [weak self] isAlert, title in
                guard let self = self else { return }
                //TODO: - 수정
                if isAlert {
                    self.showInputDialog(for: title) {
                        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        self.inputTrigger.onNext((CoinDetailInput(name: self.coinName, type: self.searchCoinType)))
                    }
                } else {
                    self.db.removeHeartItem(title)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.view.customMakeToast(ToastModel(title: nil, message: "찜하기 📭 목록에서 삭제되었습니다!"), self, .center)
                    self.inputTrigger.onNext((CoinDetailInput(name: self.coinName, type: self.searchCoinType)))
                }
            }
            cell.aiTapped = { [weak self] in
                let vc = AiViewController()
                vc.coinData = self?.coinData
                self?.push(vc)
            }
            return cell
            
        case .ads:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdsTableViewCell.id, for: indexPath) as? AdsTableViewCell else { return UITableViewCell() }
            return cell
            
        case .news:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as? NewsListTableViewCell else { return UITableViewCell() }
            cell.configure(coinData.newsData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func reloadData() {
        inputTrigger.onNext((CoinDetailInput(name: self.coinName, type: searchCoinType)))
    }
    
}
