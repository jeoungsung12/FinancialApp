//
//  HomeCoin.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit

enum HomeCoin: CaseIterable {
    case bitcoin
    case doge
    case ethereum
    case riple
    case shiba
    case solona
    case tether
    
    var image: UIImage? {
        switch self {
        case .bitcoin:
            UIImage(named: "bitcoin")
        case .doge:
            UIImage(named: "doge")
        case .ethereum:
            UIImage(named: "ethereum")
        case .riple:
            UIImage(named: "riple")
        case .shiba:
            UIImage(named: "shiba")
        case .solona:
            UIImage(named: "solona")
        case .tether:
            UIImage(named: "tether")
        }
    }
}
