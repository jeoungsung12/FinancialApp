//
//  HeaderView.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class HeaderView : UICollectionReusableView {
    static let id  : String = "HeaderView"
    //MARK: - UI Componets
    private let titleView : UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
extension HeaderView {
    private func setLayout() {
        self.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.top.equalToSuperview().inset(20)
        }
    }
    public func configure(title : String) {
        self.titleView.text = title
    }
}
