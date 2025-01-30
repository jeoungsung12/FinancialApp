//
//  HomeCoin.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit

enum HomeCoin: String, CaseIterable {
    case bitcoin = "Bitcoin"
    case doge = "Dogecoin"
    case ethereum = "Ethereum"
    case riple = "Ripple"
    case shiba = "Shiba Inu"
    case solona = "Solana"
    case tether = "Tether"
    
    var image: UIImage? {
        switch self {
        case .bitcoin:
            UIImage(named: "Bitcoin")
        case .doge:
            UIImage(named: "Dogecoin")
        case .ethereum:
            UIImage(named: "Ethereum")
        case .riple:
            UIImage(named: "Ripple")
        case .shiba:
            UIImage(named: "ShibaInu")
        case .solona:
            UIImage(named: "Solana")
        case .tether:
            UIImage(named: "Tether")
        }
    }
}
