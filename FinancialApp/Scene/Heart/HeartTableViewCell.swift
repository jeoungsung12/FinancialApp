//
//  HeartTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/22/25.
//
import UIKit
import SnapKit

final class HeartTableViewCell : UITableViewCell {
    static let id : String = "HeartTableViewCell"
    private let view = HeartCustomView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension HeartTableViewCell {
    private func setLayout() {
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
}
//MARK: - Configure
extension HeartTableViewCell {
    func configure(with model: [AddTradesModel]) {
        view.configure(with: model)
    }
}
