//
//  ViewController.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView
import Kingfisher
class MainViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    
    //데이터 관련 변수
    private var previousData: [[CoinDataWithAdditionalInfo]] = []
    private var isLoadingData = false
    private var timer: Timer?
    
    //검색
    private let searchBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .keyColor
        return btn
    }()
    //타이틀
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcher"
        label.textColor = .keyColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    //리프레시
    private let refresh : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .lightGray
        return refresh
    }()
    //테이블뷰
    private let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.isPagingEnabled = false
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBinding()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension MainViewController {
    private func setLayout() {
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.title = "차트"
        
        self.tableView.addSubview(refresh)
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        self.loadingIndicator.startAnimating()
    }
}
//MARK: - Binding
extension MainViewController {
    private func setBinding() {
        mainViewModel.inputTrigger.onNext(())
        mainViewModel.MainTable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MainTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                self.loadingIndicator.stopAnimating()
                self.refresh.endRefreshing()
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected([CoinDataWithAdditionalInfo].self)
            .subscribe { selectedModel in
                self.navigationController?.pushViewController(MainDetailViewController(coinData: selectedModel), animated: true)
            }
            .disposed(by: disposeBag)
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let screenHeight = self.tableView.frame.height
                guard !self.isLoadingData else { return }
                if offsetY > contentHeight - screenHeight {
                    self.isLoadingData = true
                    self.loadingIndicator.startAnimating()
                    self.mainViewModel.loadMoreData() {
                        self.isLoadingData = false
                        self.loadingIndicator.stopAnimating()
                    }
                }
            })
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                self.mainViewModel.inputTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        searchBtn.rx.tap
            .subscribe { _ in
                self.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateData() {
        mainViewModel.inputTrigger.onNext(())
    }
}
