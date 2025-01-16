//
//  HIDEAPIKEY++Bundle.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
extension Bundle {
    var NewsClientID : String {
        guard let file = self.path(forResource: "ApiKeyList", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["NewsClientID"] as? String else { fatalError("ApiKeyList.plist에 API_KEY를 설정해 주세요.")}
        return key
    }
    var NewsClientSecret : String {
        guard let file = self.path(forResource: "ApiKeyList", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["NewsClientSecret"] as? String else { fatalError("ApiKeyList.plist에 API_KEY를 설정해 주세요.")}
        return key
    }
    var AiAppKey : String {
        guard let file = self.path(forResource: "ApiKeyList", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["AiAppKey"] as? String else { fatalError("ApiKeyList.plist에 API_KEY를 설정해 주세요.")}
        return key
    }
    var FinancialKey : String {
        guard let file = self.path(forResource: "ApiKeyList", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["FinancialKey"] as? String else { fatalError("ApiKeyList.plist에 API_KEY를 설정해 주세요.")}
        return key
    }
}
