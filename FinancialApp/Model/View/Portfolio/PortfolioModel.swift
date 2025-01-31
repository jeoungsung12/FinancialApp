//
//  PortfolioModel.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//
import Foundation
import SwiftUICore
import UIKit

struct PortfolioModel {
    let name: String
    let quantity: Double
    let purchasePrice: Double
    let currentPrice: Double
    let rate: Double
    
    var pieModel: PiechartModel {
        get {
            return PiechartModel(name: self.name, value: self.quantity, color: .randomColor())
        }
    }
}
