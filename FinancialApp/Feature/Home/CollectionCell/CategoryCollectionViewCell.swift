//
//  CategoryCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class CategoryCollectionViewCell : UICollectionViewCell {
    static let id : String = "CategoryCollectionViewCell"
    //MARK: - UI Components
    private let categoryImage : UIImageView = {
        let btn = UIImageView()
        btn.backgroundColor = .clear
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension CategoryCollectionViewCell {
    private func setLayout() {
        self.addSubview(categoryImage)
        self.addSubview(categoryLabel)
        
        categoryImage.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.leading.trailing.equalToSuperview()
        }
        categoryLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(categoryImage.snp.bottom).offset(5)
        }
    }
}
//MARK: - Configure
extension CategoryCollectionViewCell {
    public func configure(btnImage : String, btnLabel : String) {
        self.categoryLabel.text = btnLabel
        self.categoryImage.image = UIImage(named: btnImage)
    }
}
