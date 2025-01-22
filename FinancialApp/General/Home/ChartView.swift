//
//  ChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    var chartData: [[Double]]
    
    var body: some View {
        ZStack {
            Chart {
                ForEach(chartData[0].indices, id: \.self) { index in
                    LineMark(x: .value("Date", index), y: .value("Value", chartData[0][index]))
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(Color.red)
                    
                    AreaMark(x: .value("Date", index), y: .value("Value", chartData[0][index]))
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.white.opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            Chart {
                ForEach(chartData[1].indices, id: \.self) { index in
                    LineMark(x: .value("Date", index), y: .value("Value", chartData[1][index]))
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(.green.opacity(0.7))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }
}

#Preview {
    ChartView(chartData: [[0,1,2,6,8,3,2],[9,2,4,5,0,1]])
}
