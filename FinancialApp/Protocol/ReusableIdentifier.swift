//
//  ReusableIdentifier.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import Foundation

protocol ReusableIdentifier { }
extension ReusableIdentifier {
    static var id: String {
        return String(describing: self)
    }
}
