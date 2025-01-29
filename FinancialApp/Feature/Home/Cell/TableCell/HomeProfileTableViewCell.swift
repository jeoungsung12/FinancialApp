//
//  HomeProfileTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class HomeProfileTableViewCell: UITableViewCell {
    static let id: String = "HomeProfileTableViewCell"
    private var profileView = MyProfileView()
    private let db = Database.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        profileView.configure(db.getUser())
    }
}

//MARK: - UI Layout
extension HomeProfileTableViewCell {
    private func configureHierarchy() {
        self.addSubview(profileView)
        configureLayout()
    }
    
    private func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-24)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        configureHierarchy()
    }
}
