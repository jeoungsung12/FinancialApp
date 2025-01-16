//
//  LoanCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Foundation

final class LoanCollectionViewCell : UICollectionViewCell {
    static let id : String = "LoanCollectionViewCell"
    //MARK: - UI Components
    private let titleLabel : UITextField = {
        let label = UITextField()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.clipsToBounds = true
        return label
    }()
    private let decLabel : UITextField = {
        let label = UITextField()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    private let arrow : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "고정 기준 금리"
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
private extension LoanCollectionViewCell {
    private func setLayout() {
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(decLabel)
        self.addSubview(arrow)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        decLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(5)
        }
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
}
//MARK: - Configure
extension LoanCollectionViewCell {
    public func configure(with model: LoanModel) {
        if let date = model.sfln_intrc_nm, let loan_int = model.int_r {
            self.titleLabel.text = "📊 \(loan_int) %" //고정기준금리
            self.decLabel.text = "\(date)" //대출기간
        }
    }
}
