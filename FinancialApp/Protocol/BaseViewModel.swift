//
//  BaseViewModel.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
