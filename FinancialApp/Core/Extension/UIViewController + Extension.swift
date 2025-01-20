//
//  UIViewController + Extension.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/17/25.
//

import UIKit

struct ValidateString {
    var check: Bool
    var returnString: String
}

struct AlertModel {
    let title: String?
    let message: String?
    let actionTitle: String?
}

extension UIViewController {
    
    @objc
    func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func customAlert(alert: AlertModel, vc: UIViewController, method: @escaping () -> Void) {
        let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alert.actionTitle, style: .default) { _ in
            method()
        }
        alertVC.addAction(action)
        vc.present(alertVC, animated: true)
    }
 
    func validateString(_ text: String?,_ vc: UIViewController) -> ValidateString {
        if var text = text, !text.isEmpty {
            text.removeAll(where: { $0 == " " })
            if text.count >= 2 {
                return ValidateString(check: true, returnString: text)
            }
        } else {
            self.customAlert(alert: AlertModel(title: "검색 실패!", message: "공백 제외 2글자 이상 입력해주세요.", actionTitle: "확인"), vc: vc) {
                //TODO: - Action
            }
            return ValidateString(check: false, returnString: "")
        }
        self.customAlert(alert: AlertModel(title: "검색 실패!", message: "공백 제외 2글자 이상 입력해주세요.", actionTitle: "확인"), vc: self) {
            //TODO: - Action
        }
        return ValidateString(check: false, returnString: "")
    }
}
