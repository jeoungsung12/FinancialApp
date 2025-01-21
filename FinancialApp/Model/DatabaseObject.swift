//
//  DatabaseObject.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/21/25.
//

import RealmSwift

class DatabaseObject: Object {
    @Persisted var market: String
    @Persisted var korean_name: String
    @Persisted var english_name: String
}
