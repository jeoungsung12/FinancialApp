//
//  HeartViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/02.
//
import UIKit
import RxSwift
import SnapKit
import NVActivityIndicatorView

final class HeartViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let heartViewModel = HeartViewModel()
    private let inputTrigger = PublishSubject<Void>()
    private let tableView = UITableView()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
    private let searchBar = UISearchBar()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    
    private var heartList: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inputTrigger.onNext(())
    }
    
    private func configure() {
        configureView()
    }
}

extension HeartViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        
        configureLayout()
    }
    
    private func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setBinding()
        
        self.inputTrigger.onNext(())
    }
    
    private func configureView() {
        setTableView()
        configureHierarchy()
    }
}

extension HeartViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setNavigation() {
        self.view.backgroundColor = .black
        self.navigationController?.setNaviagtion(vc: self, title: "", backTitle: "", color: .white)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HeartTableViewCell.self, forCellReuseIdentifier: HeartTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeartTableViewCell.id, for: indexPath) as? HeartTableViewCell else { return UITableViewCell() }
        cell.configure(with: [AddTradesModel(tradesData: TradesModel(market: "", trade_price: 0, trade_volume: 0, ask_bid: ""), coinName: heartList[indexPath.row], englishName: "")])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension HeartViewController {
    
    private func setBinding() {
        loadingIndicator.startAnimating()
        let input = HeartViewModel.Input(inputTrigger: inputTrigger.asObserver())
        let output = heartViewModel.transform(input: input)
        output.heartList
            .bind(onNext: { [weak self] (list:[String]) in
                self?.heartList = list
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
}
