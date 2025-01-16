//
//  NewsViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView
import Kingfisher

class NewsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate  {
    private var disposeBag = DisposeBag()
    private let newsViewModel = NewsViewModel()
    
    //데이터 관련 변수
    private var isLoadingData = false
    
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
    //검색 창
    private let searchView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.keyColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
        return view
    }()
    //검색 텍스트
    private let searchText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.backgroundColor = .white
        text.placeholder = "궁금한 기사를 검색해 보세요!"
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.frame = CGRect(x: 10, y: 3, width: 200, height: 30)
        return text
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
        view.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension NewsViewController {
    private func setLayout() {
        self.searchView.addSubview(self.searchText)
        self.navigationItem.titleView = self.searchView
        self.searchText.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.title = "뉴스"
        
        self.tableView.delegate = self
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchText.resignFirstResponder()
    }
}
//MARK: - Binding
extension NewsViewController {
    private func setBinding() {
        newsViewModel.inputTrigger.onNext(("암호화폐"))
        newsViewModel.MainTable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: NewsTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                self.loadingIndicator.stopAnimating()
                self.refresh.endRefreshing()
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(NewsItems.self)
            .subscribe { selectedModel in
                if let url = URL(string: selectedModel.element?.originallink ?? ""){
                    UIApplication.shared.open(url)
                }else{
                    if let url = URL(string: selectedModel.element?.link ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
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
                    if self.searchText.text != "" {
                        self.newsViewModel.loadMoreData(query: (self.searchText.text ?? "")) {
                            self.isLoadingData = false
                            self.loadingIndicator.stopAnimating()
                        }
                    }else{
                        self.newsViewModel.loadMoreData(query: "암호화폐") {
                            self.isLoadingData = false
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        refresh.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                if self.searchText.text != "" {
                    self.newsViewModel.inputTrigger.onNext((self.searchText.text ?? ""))
                }else{
                    self.newsViewModel.inputTrigger.onNext(("암호화폐"))
                    self.refresh.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        searchBtn.rx.tap
            .subscribe { _ in
                self.searchText.resignFirstResponder()
                if self.searchText.text != "" {
                    self.newsViewModel.inputTrigger.onNext((self.searchText.text ?? ""))
                }else{
                    self.newsViewModel.inputTrigger.onNext(("암호화폐"))
                }
            }
            .disposed(by: disposeBag)
        
    }
}
