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
                ForEach(chartData, id: \.name) { data in
                    let percentage = (data.value / totalValue) * 100
                    SectorMark(
                        angle: .value("Value", data.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(data.color)
                    .annotation(position: .overlay) {
                        Text("\(data.name)\n\(percentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(.white)
                            .bold()
                            .multilineTextAlignment(.center)
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
