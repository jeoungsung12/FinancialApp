//
//  HomeViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let homeViewModel = HomeViewModel()
    private let inputTrigger = PublishSubject<[HeartItem]>()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    private let tableView = UITableView()
    private let db = Database.shared
    
    private var homeData: CoinResult = CoinResult(chartData: [], newsData: [], ticksData: [], rate: 0) {
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

extension HomeViewController {
    
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
        inputTrigger.onNext((db.heartList))
    }
    
    private func configureView() {
        self.setNavigation("")
        self.view.backgroundColor = .black
        
        configureHierarchy()
    }
}

extension HomeViewController {
    
    private func setBinding() {
        loadingIndicator.startAnimating()
        let input = HomeViewModel.Input(chartInput: inputTrigger.asObserver())
        let output = homeViewModel.transform(input: input)
        
        output.chartOutput.bind { data in
            self.homeData = data
            self.configureTableView()
            self.loadingIndicator.stopAnimating()
        }.disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HomeProfileTableViewCell.self, forCellReuseIdentifier: HomeProfileTableViewCell.id)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: ChartTableViewCell.id)
        tableView.register(TicksTableViewCell.self, forCellReuseIdentifier: TicksTableViewCell.id)
        tableView.register(AdsTableViewCell.self, forCellReuseIdentifier: AdsTableViewCell.id)
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeItems.allCases[indexPath.row] {
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeProfileTableViewCell.id, for: indexPath) as? HomeProfileTableViewCell else { return UITableViewCell() }
            let rate = homeData.rate
            cell.configure(rate)
            cell.sheetProfile = { [weak self] in
                let vc = PortfolioViewController()
                self?.push(vc)
            }
            return cell
            
        case .chart:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.id, for: indexPath) as? ChartTableViewCell else { return UITableViewCell() }
            cell.coinData = homeData.chartData
            cell.heartTapped = { [weak self] isAlert, title in
                guard let self = self else { return }
                //TODO: - 수정
                if isAlert {
                    self.showInputDialog(for: title) {
                        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        self.inputTrigger.onNext((self.db.heartList))
                        cell.collectionView.reloadData()
                    }
                } else {
                    self.db.removeHeartItem(title)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.view.customMakeToast(ToastModel(title: nil, message: "찜하기 📭 목록에서 삭제되었습니다!"), self, .center)
                    self.inputTrigger.onNext((db.heartList))
                    cell.collectionView.reloadData()
                }
            }
            return cell
            
        case .ticks:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TicksTableViewCell.id, for: indexPath) as? TicksTableViewCell else { return UITableViewCell() }
            cell.ticksData = homeData.ticksData
            return cell
            
        case .ads:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdsTableViewCell.id, for: indexPath) as? AdsTableViewCell else { return UITableViewCell() }
            return cell
            
        case .news:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as? NewsListTableViewCell else { return UITableViewCell() }
            cell.newsData = homeData.newsData
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
