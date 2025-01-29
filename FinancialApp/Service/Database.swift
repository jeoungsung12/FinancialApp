//
//  Database.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//

import UIKit

final class Database {
    static let shared = Database()
    
    private init() { }
    
    private let ud = UserDefaults.standard
    private enum Key: String {
        case isUser = "isUser"
        case userInfo = "userInfo"
        case heartList = "heartList"
    }
    
    private func get<T>(_ key: Key, binding: T) -> T {
        return ud.value(forKey: key.rawValue) as? T ?? binding
    }
    
    private func set<T>(_ key: Key, value: T) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    var isUser: Bool {
        get {
            return self.get(.isUser, binding: false)
        }
        set {
            self.set(.isUser, value: newValue)
        }
    }
    
    var heartList: [String] {
        get {
            return self.get(.heartList, binding: [])
        }
        set {
            self.set(.heartList, value: newValue)
        }
    }
    
    var userInfo: [String] {
        get {
            guard var userInfo = self.get(.userInfo, binding: []) as? [String] else { return [] }
            let heartList = self.heartList
            if userInfo.count > 1 {
                userInfo[2] = heartList.count.formatted()
            }
            return userInfo
        }
        set {
            self.set(.userInfo, value: newValue)
        }
    }
    
    func deleteData(_ market: String) {
        self.heartList = self.heartList.filter({ $0 != market })
    }
    
    
}

extension Database {
    func removeAll(_ model: String) {
        UserDefaults.standard.removeObject(forKey: model)
    }
    
    func removeHeartButton(_ remove: String) {
        self.heartList = heartList.filter { $0 != remove }
    }
    
    func removeUserInfo() {
        self.isUser = false
        removeAll(Key.userInfo.rawValue)
        removeAll(Key.heartList.rawValue)
    }
    
    func getUser() -> UserInfo {
        return UserInfo(nickname: self.userInfo[0], profile: UIImage(named: self.userInfo[1]), coinCount: self.userInfo[2], date: self.userInfo[3])
    }
}
