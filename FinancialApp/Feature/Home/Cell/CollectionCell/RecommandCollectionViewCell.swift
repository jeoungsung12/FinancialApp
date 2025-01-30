//
//  RecommandCollectionViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/30/25.
//

import UIKit
import SnapKit

final class RecommandCollectionViewCell: UICollectionViewCell {
    static let id: String = "RecommandCollectionViewCell"
    
    private var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ image: UIImage?) {
        imageView.image = image
    }
}

extension RecommandCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        configureLayout()
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 30
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .darkGray.withAlphaComponent(0.5)
        
        imageView.contentMode = .scaleAspectFit
        configureHierarchy()
    }
}
