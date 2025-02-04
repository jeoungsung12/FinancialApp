//
//  CustomProfileButton.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class CustomProfileButton: UIButton {
    private let overlayImage = UIImageView()
    private var isItemSelected: Bool = false
    let containerView = UIView()
    let profileImage = UIImageView()
    
    init(_ size: CGFloat,_ isSelected: Bool) {
        super.init(frame: .zero)
        isItemSelected = isSelected
        configureView(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomProfileButton {
    
    private func configureHierarchy(_ size: CGFloat) {
        self.addSubview(profileImage)
        self.containerView.addSubview(overlayImage)
        self.addSubview(containerView)
        configureLayout(size)
    }
    
    private func configureLayout(_ size: CGFloat) {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(size)
        }
        
        containerView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalToSuperview().inset(30)
        }
        
        overlayImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    private func configureView(_ size: CGFloat) {
        self.alpha = (isItemSelected ? 1 : 0.5)
        
        profileImage.contentMode = .scaleAspectFit
        profileImage.setBorder(isItemSelected, size / 2)
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = .white
        
        overlayImage.tintColor = .black
        overlayImage.image = UIImage(systemName: "camera.fill")
        
        configureHierarchy(size)
    }
}
