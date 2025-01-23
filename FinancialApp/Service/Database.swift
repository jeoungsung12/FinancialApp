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
    private let db = UserDefaults.standard
    
    var market: [String] {
        get {
            guard let result = db.array(forKey: "market") as? [String] else { return [] }
            return result
        }
        set {
            db.removeObject(forKey: "market")
            db.setValue(newValue, forKey: "market")
        }
    }
    
    func deleteData(market: String) {
        let data = self.market.filter({ $0 != market })
        db.removeObject(forKey: "market")
        self.market = data
    }
}
