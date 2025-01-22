//
//  Database.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//

import Foundation
import RealmSwift

final class Database {
    static let shared = Database()
    
    private init() { }
    private let db = try! Realm()
    
    func setData(_ market: String) {
        let databaseObject = DatabaseObject()
        databaseObject.market = market
        try! db.write {
            db.add(databaseObject)
        }
    }
    
    func getData() -> Results<DatabaseObject> {
        let result = db.objects(DatabaseObject.self)
        return result
    }
    
    func deleteData(_ market: String) {
        let databaseObject = DatabaseObject()
        databaseObject.market = market
        try! db.write {
            db.delete(databaseObject)
        }
    }
    
}
