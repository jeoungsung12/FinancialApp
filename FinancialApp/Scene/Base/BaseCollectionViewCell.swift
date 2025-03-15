//
//  BaseCollectionViewCell.swift
//  CryptoApp
//
//  Created by 정성윤 on 3/6/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = true
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
