//
//  CandleChartView.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//

import SwiftUI
import Charts
import DGCharts

struct CandleChartView: View {
    var chartData: [CandleModel]
    
    var body: some View {
        Chart {
            ForEach(Array(zip(chartData.indices, chartData)), id: \.1) { index, candle in
                RectangleMark(
                    x: .value("index", index),
                    yStart: .value("low", candle.low_price),
                    yEnd: .value("high", candle.high_price),
                    width: 2
                )
                .foregroundStyle(.green)
                
                RectangleMark(
                    x: .value("index", index),
                    yStart: .value("open", candle.opening_price),
                    yEnd: .value("close", candle.trade_price),
                    width: 6
                )
                .foregroundStyle(.red)
            }
        }
        .chartXAxis(.hidden)
//        .chartYAxis(.hidden)
    }
}

#Preview {
    CandleChartView(chartData: [CandleModel(market: "", opening_price: 3, high_price: 5, low_price: 1, trade_price: 4)])
}
