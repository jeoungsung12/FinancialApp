//
//  MainTableViewCell.swift
//  Baedug
//
//  Created by 정성윤 on 2024/03/03.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import Charts
import DGCharts
class MainTableViewCell : UITableViewCell {
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        view.font = UIFont.systemFont(ofSize: 9)
        view.isEditable = false
        view.isUserInteractionEnabled = false
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
//MARK: - UI Layout
extension MainTableViewCell {
    private func setupUI() {
        let contentView = self.contentView
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(0)
        }
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
        contentView.addSubview(totalView)
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
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
    func configure(with model: [CoinDataWithAdditionalInfo]) {
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
            chart.data = nil
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
}
