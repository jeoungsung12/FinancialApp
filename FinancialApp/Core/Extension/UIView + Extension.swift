//
//  UIView + Extension.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/23/25.
//

import UIKit
import Toast

struct ToastModel {
    let title: String?
    let message: String?
}

extension UIView {
    
    func customMakeToast(_ text: ToastModel,_ vc: UIViewController,_ position: ToastPosition = .bottom) {
        self.makeToast(text.message, duration: 1.5, position: position, title: text.title, image: nil) { didTap in }
    }
}
