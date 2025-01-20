//
//  SearchViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/02.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import DGCharts
import NVActivityIndicatorView
import Kingfisher

class SearchViewController : UIViewController, UITextFieldDelegate {
    private var disposeBag = DisposeBag()
    private let searchViewModel = SearchViewModel()
    private var coinData : [CoinDataWithAdditionalInfo] = []
    //MARK: UI Components
//    private lazy var tapGesture : UITapGestureRecognizer = {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        return gesture
//    }()
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
    //코인 차트
    private let chart : LineChartView = {
        let view = LineChartView()
        view.isUserInteractionEnabled = false
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.xAxis.labelPosition = .top
        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["전일 종가, 저가, 고가, 시가"])
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.noDataText = ""
        view.backgroundColor = .white
        return view
    }()
    private let decText : UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.textColor = .gray
        view.isEditable = false
        view.font = UIFont.systemFont(ofSize: 9)
        view.isUserInteractionEnabled = false
        return view
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension SearchViewController {
    private func setLayout() {
        self.title = ""
        self.view.backgroundColor = .white
        self.searchView.addSubview(searchText)
        self.navigationItem.titleView = searchView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        self.view.clipsToBounds = true
//        self.view.addGestureRecognizer(tapGesture)
        self.searchText.delegate = self
        
        totalView.addSubview(titleLabel)
        totalView.addSubview(availLabel)
        totalView.addSubview(price)
        totalView.addSubview(arrow)
        totalView.addSubview(chart)
        totalView.addSubview(decText)
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
        chart.snp.makeConstraints { make in
            make.top.equalTo(availLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(arrow.snp.leading).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        decText.snp.makeConstraints { make in
            make.top.equalTo(availLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(0)
            make.width.equalToSuperview().dividedBy(2.5)
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
            make.height.equalTo(150)
        }
        MoveBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
            make.height.equalTo(150)
        }
    }
    private func setChart(name: String, close: Double, low: Double, high: Double, open: Double, now : Double) {
        var entries: [ChartDataEntry] = []
        entries.append(ChartDataEntry(x: 0, y: close))
        entries.append(ChartDataEntry(x: 1, y: low))
        entries.append(ChartDataEntry(x: 2, y: high))
        entries.append(ChartDataEntry(x: 3, y: open))
        entries.append(ChartDataEntry(x: 4, y: now))
        
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.colors = [.graph3, .graph2, .graph1, .graph3, .graph3]
        dataSet.valueTextColor = .black
        dataSet.highlightEnabled = false
        dataSet.circleRadius = 2.0
        dataSet.circleColors = [.black]
        dataSet.drawValuesEnabled = false
        let data = LineChartData(dataSet: dataSet)
        
        chart.data = data
    }
    private func setValue(model : [CoinDataWithAdditionalInfo]) {
        let coinName = model.compactMap{ $0.coinName } //코인 이름
        let coinMarket = model.compactMap { $0.coinData.market } //코인 마켓
        let change = model.compactMap{ $0.coinData.change } //코인 상/하/보합
        let change_rate = model.compactMap{ $0.coinData.change_rate } //코인 변화율
        let volume = model.compactMap{ $0.coinData.acc_trade_volume_24h } //코인 누적 거래량
        let trade_price = model.compactMap{ $0.coinData.trade_price } //코인 종가(현재가)
        
        //차트
        let close = model.compactMap{ $0.coinData.prev_closing_price } //종가
        let low = model.compactMap{ $0.coinData.low_price } //저가
        let high = model.compactMap{ $0.coinData.high_price } //고가
        let open = model.compactMap{ $0.coinData.opening_price } //시가
        
        titleLabel.text = "\(coinName[0]) \(coinMarket[0])"
        if trade_price[0] >= 10000 {
            price.text = "\(trade_price[0] / 10000)만 KRW"
        }else{
            price.text = "\(trade_price[0]) KRW"
        }
        if change[0] == "EVEN"{
            arrow.textColor = .gray
            arrow.text = "보합"
        }else if change[0] == "RISE" {
            arrow.textColor = .systemRed
            arrow.text = "+\(change_rate[0])% 📈"
            setChart(name: coinName[0], close: close[0], low: low[0], high: high[0], open: open[0], now: trade_price[0])
        }else if change[0] == "FALL" {
            arrow.textColor = .systemBlue
            arrow.text = "-\(change_rate[0])% 📉"
            setChart(name: coinName[0], close: close[0], low: low[0], high: high[0], open: open[0], now: trade_price[0])
        }
        availLabel.text = "24h : \(volume[0])"
        decText.text = "전일 종가 : \(close[0])\n저가 : \(low[0])\n고가 : \(high[0])\n시가 : \(open[0])"
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
extension SearchViewController {
    private func setBinding() {
        searchBtn.rx.tap
            .subscribe { _ in
                self.hideKeyboard()
                if self.searchText.text != nil {
                    self.loadingIndicator.startAnimating()
                    self.searchViewModel.searchInputrigger.onNext((self.searchText.text ?? ""))
                    self.searchText.text = ""
                }else{}
            }
            .disposed(by: disposeBag)
        searchViewModel.searchResult
            .subscribe { coinData in
                self.coinData = coinData
                self.setValue(model: coinData)
                self.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
        MoveBtn.rx.controlEvent(.touchUpInside)
            .subscribe { _ in
                self.navigationController?.pushViewController(MainDetailViewController(coinData: self.coinData), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
