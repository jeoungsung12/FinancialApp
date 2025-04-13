//
//  LineChartView.swift
//  FinancialApp
//
//  Created by 정성윤 on 4/13/25.
//

import SwiftUI
import Charts
import DGCharts

struct LineChartView: View {
    var chartData: [CandleModel]
    
    private var normalizedData: [Double] {
        guard let firstPrice = chartData.first?.trade_price, !chartData.isEmpty else {
            return []
        }
        
        return chartData.map { ($0.trade_price - firstPrice) / firstPrice * 100 }
    }
    
    private var minPrice: Double {
        chartData.map { $0.trade_price }.min() ?? 0
    }
    
    private var maxPrice: Double {
        chartData.map { $0.trade_price }.max() ?? 0
    }
    
    private var yAxisRange: (min: Double, max: Double) {
        let mid = (minPrice + maxPrice) / 2
        let range = maxPrice - minPrice
        
        let minRange = mid * 0.0001
        let effectiveRange = max(range, minRange)
        
        return (mid - effectiveRange, mid + effectiveRange)
    }
    
    var body: some View {
        Chart {
            ForEach(Array(zip(chartData.indices, chartData)), id: \.1) { index, candle in
                LineMark(
                    x: .value("index", index),
                    y: .value("value", candle.trade_price)
                )
                .foregroundStyle(.green)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisValueLabel()
            }
        }
        .chartYScale(domain: [yAxisRange.min, yAxisRange.max])
    }
}
