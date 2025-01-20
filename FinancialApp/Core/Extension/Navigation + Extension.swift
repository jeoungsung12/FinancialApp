//
//  Navigation + Extension.swift
//  SeSAC_Week4(Assignment5)
//
//  Created by 정성윤 on 1/17/25.
//

import UIKit

extension UINavigationController {
    
    func setNaviagtion(vc: UIViewController, title: String, backTitle: String, color: UIColor) {
        vc.navigationItem.title = title
        vc.navigationController?.navigationBar.tintColor = color
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
    }
    
}
