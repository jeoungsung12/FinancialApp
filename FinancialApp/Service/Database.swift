//
//  Database.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//

import Foundation

final class Database {
    static let shared = Database()
    
    private init() { }
    
    private let ud = UserDefaults.standard
    private enum Key: String {
        case market = "market"
    }
    
    private func get<T>(_ key: Key, binding: T) -> T {
        return ud.value(forKey: key.rawValue) as? T ?? binding
    }
    
    private func set<T>(_ key: Key, value: T) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    var market: [String] {
        get {
            return self.get(.market, binding: [])
        }
        set {
            self.set(.market, value: newValue)
        }
    }
    
    func deleteData(market: String) {
        self.market = self.market.filter({ $0 != market })
    }
    
}
