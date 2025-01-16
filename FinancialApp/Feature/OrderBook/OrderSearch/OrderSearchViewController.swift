//
//  OrderSearchViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import DGCharts
import NVActivityIndicatorView
import Kingfisher

class OrderSearchViewController : UIViewController, UITextFieldDelegate {
    private var disposeBag = DisposeBag()
    private let ordersearchViewModel = OrderSearchViewModel()
    private var coinData : [AddTradesModel] = []
    private var timer: Timer?
    
    //MARK: UI Components
    private lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
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
        text.placeholder = "코인명(한/영)"
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.frame = CGRect(x: 10, y: 3, width: 200, height: 30)
        return text
    }()
    //검색 버튼
    private let searchBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .keyColor
        return btn
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        return view
    }()
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    //코인 이름
    private let titleLabel : UITextField = {
        let label = UITextField()
        label.isEnabled = false
        label.textColor = .black
        label.text = ""
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    //거래량 총액
    private let availLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .white
        return label
    }()
    //코인 가격
    private let price : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.layer.borderWidth = 1
        return label
    }()
    //코인 상승세
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    private let MoveBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.clipsToBounds = true
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setupTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension OrderSearchViewController {
    private func setLayout() {
        self.title = ""
        self.view.backgroundColor = .white
        self.searchView.addSubview(searchText)
        self.navigationItem.titleView = searchView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
        self.view.addGestureRecognizer(tapGesture)
        self.searchText.delegate = self
        
        totalView.addSubview(titleLabel)
        totalView.addSubview(availLabel)
        totalView.addSubview(price)
        totalView.addSubview(arrow)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        availLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(price.snp.bottom).offset(5)
        }
        self.view.addSubview(totalView)
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(MoveBtn)
        
        loadingIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
            make.height.equalTo(80)
        }
        MoveBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
            make.height.equalTo(80)
        }
    }
    private func setValue(model : [AddTradesModel]) {
        let name = model.compactMap{ $0.coinName }.first ?? ""
        let market = model.compactMap{ $0.tradesData.market }.first ?? ""
        let price = model.compactMap{ $0.tradesData.trade_price }.first ?? 0
        let ask_bid = model.compactMap{ $0.tradesData.ask_bid }.first ?? ""
        let volume = model.compactMap{ $0.tradesData.trade_volume }.first ?? 0
        self.titleLabel.text = "\(name) \(market)"
        self.price.text = String(price)
        if ask_bid == "ASK" {
            self.price.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.white.cgColor
            }
            self.arrow.text = "📈매수"
            self.arrow.textColor = .red
        }else {
            self.price.layer.borderColor = UIColor.blue.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.price.layer.borderColor = UIColor.white.cgColor
            }
            self.arrow.text = "📉매도"
            self.arrow.textColor = .blue
        }
        availLabel.text = "\(volume)"
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func hideKeyboard() {
        self.searchText.resignFirstResponder()
    }
}
//MARK: - setBinding
extension OrderSearchViewController {
    private func setBinding() {
        searchBtn.rx.tap
            .subscribe { _ in
                self.hideKeyboard()
                if self.searchText.text != nil {
                    self.loadingIndicator.startAnimating()
                    self.ordersearchViewModel.searchInputrigger.onNext((self.searchText.text ?? ""))
                    self.searchText.text = ""
                }else{}
            }
            .disposed(by: disposeBag)
        ordersearchViewModel.searchResult
            .subscribe { coinData in
                self.coinData = coinData
                self.setValue(model: coinData)
                self.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
        MoveBtn.rx.controlEvent(.touchUpInside)
            .subscribe { _ in
                self.navigationController?.pushViewController(OrderBookDetailViewController(coinData: self.coinData), animated: true)
            }
            .disposed(by: disposeBag)
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateData() {
        var updateString : String = ""
        if let range = titleLabel.text?.range(of: " ") {
            if let substring = titleLabel.text?[..<range.lowerBound]{
                updateString = String(substring)
            }
        }
        self.ordersearchViewModel.searchInputrigger.onNext((updateString))
    }
}
