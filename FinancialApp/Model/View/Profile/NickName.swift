//
//  NickName.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import Foundation

struct NickName {
    
    enum NickNameType: String {
        case success = "사용할 수 있는 닉네임이에요"
        case notCount = "2글자 이상 10글자 미만으로 설정해 주세요"
        case notSpecial = "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case notNumeric = "닉네임에 숫자는 포함할 수 없어요"
    }
    
    func checkNickName(_ text: String) -> NickNameType {
        if ((text.count < 2) || (text.count >= 10)) {
            return NickNameType.notCount
        }
        
        if (text.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil) {
            return NickNameType.notSpecial
        }
        
        if (text.rangeOfCharacter(from: .decimalDigits) != nil) {
            return NickNameType.notNumeric
        }
        
        return NickNameType.success
    }
}
