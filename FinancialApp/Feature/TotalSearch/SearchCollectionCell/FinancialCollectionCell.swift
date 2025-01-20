//
//  FinancialCollectionCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class FinancialCollectionCell : UICollectionViewCell {
    static let id = "FinancialCollectionCell"
    //MARK: - UI Components
    private let title : UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    private let titleLabel : UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.textColor = .black
        label.textAlignment = .left
        label.isScrollEnabled = false
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
private extension FinancialCollectionCell {
    private func setLayout() {
        self.addSubview(title)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        
        title.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.leading.top.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
//MARK: - Action
extension FinancialCollectionCell {
    func configure(with model: FinancialModel) {
        if let name = model.cur_nm, let unit = model.cur_unit, let ttb = model.ttb, let tts = model.tts, let deal = model.deal_bas_r {
            self.title.text = "\(name) \(unit)"
            self.titleLabel.text = "📥\(ttb)₩\n📤\(tts)₩"
            self.dateLabel.text = "매매 기준율 : \(deal)₩"
        }
    }
}
