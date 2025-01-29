//
//  UIViewController + Extension.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/17/25.
//

import UIKit

enum AlertType: String, CaseIterable {
    case ok = "확인"
    case cancel = "취소"
}

extension UIViewController {
    
    func push(_ destination: UIViewController) {
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sheet(_ vc: UIViewController) {
        let nv = UINavigationController(rootViewController: vc)
        self.present(nv, animated: true)
    }
    
    func errorPresent(_ type: NetworkError.CustomError) {
//        let vc = ErrorViewController(type.errorDescription ?? "")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false)
    }
    
    func setRootView(_ rootVC: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = rootVC
    }
    
    func setNavigation(_ title: String = "",_ backTitle: String = "",_ color: UIColor = .white) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        self.navigationItem.title = title
        let back = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.tintColor = color
        navigationBar.compactAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func tapGesture(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func customAlert(_ title: String = "",_ message: String = "",_ action: [AlertType] = [.ok],_ method: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for type in action {
            switch type {
            case .ok:
                let action = UIAlertAction(title: type.rawValue, style: .default) { _ in
                    method()
                }
                alertVC.addAction(action)
            case .cancel:
                let action = UIAlertAction(title: type.rawValue, style: .destructive )
                alertVC.addAction(action)
            }
        }
        
        self.present(alertVC, animated: true)
    }
    
    func showInputDialog(for crypto: String) {
        let alert = UIAlertController(title: "\(crypto) 정보 입력", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "수량 입력"
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "매수가 입력"
            textField.keyboardType = .decimalPad
        }
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            let quantity = alert.textFields?[0].text ?? "0"
            let price = alert.textFields?[1].text ?? "0"
            if let market = cryptoData.filter({$0.korean_name == crypto}).first {
                Database.shared.removeHeartItem(market.market)
                Database.shared.addHeartItem(name: market.market, quantity: quantity, price: price)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
