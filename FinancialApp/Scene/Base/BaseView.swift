//
//  BaseView.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
        setBinding()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBinding() { }
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
}
