//
//  ChartView.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import SwiftUI
import Charts
import SwiftUI
import Charts

struct PiechartModel {
    var name: String
    var value: Double
    var color: Color
}

struct PieChartView: View {
    var chartData: [PiechartModel]
    
    private var totalValue: Double {
        chartData.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        ZStack {
            Chart {
                let sortedChartData = chartData.sorted(by: { $0.value > $1.value })
                
                ForEach(sortedChartData.indices, id: \.self) { index in
                    let percentage = (sortedChartData[index].value / totalValue) * 100
                    SectorMark(
                        angle: .value("Value", sortedChartData[index].value),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(sortedChartData[index].color)
                    .annotation(position: .overlay) {
                        if index < 3 {
                            Text("\(sortedChartData[index].name)\n\(percentage, specifier: "%.1f")%")
                                .font(.caption)
                                .foregroundColor(.white)
                                .bold()
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 80)
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(chartData: [
            PiechartModel(name: "Bitcoin", value: 40, color: .orange),
            PiechartModel(name: "Ethereum", value: 30, color: .blue),
            PiechartModel(name: "XRP", value: 20, color: .green),
            PiechartModel(name: "Solana", value: 10, color: .purple)
        ])
    }
}
