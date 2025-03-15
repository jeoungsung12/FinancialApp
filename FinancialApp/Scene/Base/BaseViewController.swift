//
//  BaseViewController.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
        setBinding()
    }
    
    func setBinding() { }
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
    
    deinit {
        print(#function, self)
    }
}
