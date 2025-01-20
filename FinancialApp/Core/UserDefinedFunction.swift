//
//  UserDefinedFunction.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/18/25.
//

import Foundation

final class UserDefinedFunction {
    static let shared = UserDefinedFunction()
    
    private init() { }
    
    func dateFormatter(date: String?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return date
    }
    
    func replacingOccurrences(_ text: String?) -> String {
        guard let text = text else { return  "" }
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).removingHTMLEntities()
    }
    
}
