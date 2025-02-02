//
//  ProfileImageCollectionViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    static let id: String = "ProfileImageCollectionViewCell"
    private let size = ((UIScreen.main.bounds.width) - (12 * 5)) / 4
    lazy var profileButton = CustomProfileButton(size, false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            configureView()
        }
    }
    
    func configure(_ image: UIImage?) {
        profileButton.profileImage.image = image
    }
}

//MARK: - Configure UI
extension ProfileImageCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(profileButton)
        configureLayout()
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        profileButton.containerView.isHidden = true
        profileButton.alpha = (isSelected ? 1 : 0.5)
        profileButton.isUserInteractionEnabled = false
        profileButton.profileImage.setBorder(isSelected, size / 2)
        
        configureHierarchy()
    }
    
}
