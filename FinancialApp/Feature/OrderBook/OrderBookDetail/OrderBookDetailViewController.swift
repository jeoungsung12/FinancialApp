//
//  OrderBookDetailViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DGCharts
import Kingfisher
import iOSDropDown
import NVActivityIndicatorView

class OrderBookDetailViewController : UIViewController {
    private var disposeBag = DisposeBag()
    private let orderBookDetailViewModel = OrderBookDetailViewModel()
    private var timer: Timer?
    
    let coinData : [AddTradesModel]
    init(coinData : [AddTradesModel]) {
        self.coinData = coinData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    //상위 뷰
    private let coinInfoView : UIView = {
        let view = UIView()
        view.backgroundColor = .keyColor
        view.clipsToBounds = true
        return view
    }()
    //코인이미지
    private let coinImage : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = nil
        return view
    }()
    //에러 텍스트
    private let errorText : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.isScrollEnabled = false
        text.clipsToBounds = true
        text.isUserInteractionEnabled = false
        text.text = ""
        return text
    }()
    //코인 정보
    private let coinText : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 10)
        text.textAlignment = .left
        text.backgroundColor = .clear
        text.isScrollEnabled = false
        text.clipsToBounds = true
        text.isUserInteractionEnabled = false
        return text
    }()
    //코인 스크롤
    private let coinScroll : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()
    //코인 스택
    private let coinStack : UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fill
        return view
    }()
    //호가
    private let orderBookView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .BackColor
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    //호가텍스트
    private let orderBookText : UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.textColor = .gray
        text.font = UIFont.boldSystemFont(ofSize: 12)
        text.textAlignment = .left
        text.backgroundColor = .BackColor
        text.isScrollEnabled = false
        text.clipsToBounds = true
        text.isUserInteractionEnabled = false
        return text
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        return view
    }()
    //차트 스크롤
    private let chartScroll : UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()
    //매수 호가 정보
    private let askBarChart : HorizontalBarChartView = {
        let view = HorizontalBarChartView()
        view.isUserInteractionEnabled = false
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.xAxis.drawLabelsEnabled = true
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.noDataText = ""
        view.legend.textColor = .black
        view.xAxis.labelPosition = .bottom
        view.backgroundColor = .clear
        return view
    }()
    //매도 호가 정보
    private let bidBarChart : HorizontalBarChartView = {
        let view = HorizontalBarChartView()
        view.isUserInteractionEnabled = false
        view.drawGridBackgroundEnabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.doubleTapToZoomEnabled = false
        view.xAxis.drawLabelsEnabled = true
        view.leftAxis.drawLabelsEnabled = false
        view.rightAxis.drawLabelsEnabled = false
        view.noDataText = ""
        view.legend.textColor = .black
        view.xAxis.labelPosition = .bottom
        view.backgroundColor = .clear
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .keyColor
        self.navigationController?.navigationBar.tintColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCoinData()
        setBinding()
        setupTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        disposeBag = DisposeBag()
    }
}
//MARK: - UI Layout
extension OrderBookDetailViewController {
    private func setLayout() {
        self.view.clipsToBounds = true
        self.view.backgroundColor = .keyColor
        
        self.coinScroll.addSubview(coinStack)
        
        self.coinInfoView.addSubview(coinImage)
        self.coinInfoView.addSubview(coinText)
        self.coinInfoView.addSubview(coinScroll)
        self.coinInfoView.addSubview(errorText)
        self.view.addSubview(coinInfoView)
        
        self.chartScroll.addSubview(orderBookText)
        self.chartScroll.addSubview(askBarChart)
        self.chartScroll.addSubview(bidBarChart)
        
        self.orderBookView.addSubview(chartScroll)
        self.view.addSubview(orderBookView)
        self.view.addSubview(loadingIndicator)
        
        coinImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview().inset(10)
        }
        coinText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(coinImage.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        coinScroll.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(coinText.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
        errorText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
        coinInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(self.view.frame.height / 10)
            make.height.equalToSuperview().dividedBy(3)
        }
        orderBookText.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        bidBarChart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalTo(orderBookText.snp.bottom).offset(10)
            make.height.equalTo(300)
            make.width.equalToSuperview().inset(10)
        }
        askBarChart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalTo(bidBarChart.snp.bottom).offset(10)
            make.height.equalTo(300)
            make.width.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        chartScroll.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        orderBookView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(50)
            make.top.equalTo(coinInfoView.snp.bottom).offset(30)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
    private func addBtnStack(links : Links) {
        coinStack.subviews.forEach { $0.removeFromSuperview() }
        var index = 0
        
        if let explorer = links.explorer {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "globe"), for: .normal)
            Btn.tintColor = .graph2
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: explorer.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        if let facebook = links.facebook {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "person"), for: .normal)
            Btn.tintColor = .blue
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: facebook.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        if let reddit = links.reddit {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            Btn.tintColor = .green
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: reddit.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        if let code = links.source_code {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "doc.text.fill"), for: .normal)
            Btn.tintColor = .black
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: code.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        if let website = links.website {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "safari.fill"), for: .normal)
            Btn.tintColor = .systemBlue
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: website.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        if let youtue = links.youtube {
            index += 1
            let Btn = UIButton()
            Btn.backgroundColor = .white
            Btn.layer.cornerRadius = 10
            Btn.layer.masksToBounds = true
            Btn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            Btn.tintColor = .red
            Btn.snp.makeConstraints { make in make.width.height.equalTo(40)}
            Btn.rx.controlEvent(.touchUpInside)
                .subscribe { _ in
                    if let url = URL(string: youtue.first ?? "") {
                        UIApplication.shared.open(url)
                    }
                }
                .disposed(by: disposeBag)
            coinStack.addArrangedSubview(Btn)
        }
        coinStack.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(0)
            make.width.equalTo((40 * index) + (20 * (index - 1)))
            make.top.bottom.equalToSuperview().inset(0)
        }
    }
}
//MARK: - setValue
extension OrderBookDetailViewController {
    private func setCoinData() {
        //코인 정보
        let coinName = coinData.compactMap{ $0.coinName }
        let coinMarket = coinData.compactMap{ $0.tradesData.market }
        self.titleLabel.text = "\(coinName[0]) \(coinMarket[0])"
        self.navigationItem.titleView = titleLabel
    }
    private func setOrder(orderBook : [OrderBookModel]) {
        orderBookText.text = "📌호가 모아보기 기능은 원화마켓(KRW)에서만 지원하므로 BTC, USDT 마켓의 경우 0만 존재합니다."
        self.bidsetChart(ask_bid: orderBook.compactMap{ $0.orderbook_units }.first ?? [])
        self.asksetChart(ask_bid: orderBook.compactMap{ $0.orderbook_units }.first ?? [])
    }
    private func bidsetChart(ask_bid : [Units]) {
        var entries: [BarChartDataEntry] = []
        var xAxisValue : [String] = []
        for (index, unit) in ask_bid.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: unit.bid_size ?? 0))
            xAxisValue.append("\(unit.bid_price ?? 0)")
        }
        let dataSet = BarChartDataSet(entries: entries, label: "매도")
        dataSet.colors = [.graph2]
        dataSet.valueTextColor = .black
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = true
        dataSet.valueColors = [.blue]
        let data = BarChartData(dataSet: dataSet)
        bidBarChart.xAxis.labelCount = xAxisValue.count
        bidBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisValue)
        bidBarChart.data = data
    }
    private func asksetChart(ask_bid : [Units]) {
        var entries: [BarChartDataEntry] = []
        var xAxisValue : [String] = []
        for (index, unit) in ask_bid.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: unit.ask_size ?? 0))
            xAxisValue.append("\(unit.ask_price ?? 0)")
        }
        let dataSet = BarChartDataSet(entries: entries, label: "매수")
        dataSet.colors = [.graph1]
        dataSet.valueTextColor = .black
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = true
        dataSet.valueColors = [.red]
        let data = BarChartData(dataSet: dataSet)
        askBarChart.xAxis.labelCount = xAxisValue.count
        askBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisValue)
        askBarChart.data = data
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateData() {
        let market = coinData.compactMap({ $0.tradesData.market }).first ?? ""
        orderBookDetailViewModel.orderBookTrigger.onNext(market)
    }
}
//MARK: - SetBinding
extension OrderBookDetailViewController {
    private func setBinding() {
        let english_name = coinData.compactMap({ $0.englishName }).first ?? ""
        let market = coinData.compactMap({ $0.tradesData.market }).first ?? ""
        orderBookDetailViewModel.imageTrigger.onNext(english_name)
        self.loadingIndicator.startAnimating()
        orderBookDetailViewModel.imageResult
            .subscribe { paprikaModel in
                let hasing = paprikaModel.element?.hash_algorithm ?? ""
                if let links = paprikaModel.element?.links{
                    self.addBtnStack(links: links)
                }
                let imageUrl = paprikaModel.element?.logo
                if imageUrl != "" {
                    if let urlString = imageUrl {
                        if let url = URL(string: urlString) {
                            self.coinImage.kf.setImage(with: url)
                            self.coinText.text = "해싱 알고리즘 : \(hasing)"
                            self.loadingIndicator.stopAnimating()
                        }else{
                            self.errorText.text = "해당 암호화폐는 정보를 지원하지 않습니다⚠️"
                            self.loadingIndicator.stopAnimating()
                        }
                    }else{
                        self.errorText.text = "해당 암호화폐는 정보를 지원하지 않습니다⚠️"
                        self.loadingIndicator.stopAnimating()
                    }
                }else{
                    self.errorText.text = "해당 암호화폐는 정보를 지원하지 않습니다⚠️"
                    self.loadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
        orderBookDetailViewModel.orderBookTrigger.onNext(market)
        orderBookDetailViewModel.orderBookResult.subscribe { data in
            self.setOrder(orderBook: data)
        }
        .disposed(by: disposeBag)
    }
}
