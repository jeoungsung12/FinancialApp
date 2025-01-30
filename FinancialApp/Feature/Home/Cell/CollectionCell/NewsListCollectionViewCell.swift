//
//  NewsListCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/17.
//

import UIKit
import SnapKit

final class NewsListCell : UITableViewCell {
    static let id = "NewsListCollectionViewCell"
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let decLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .lightGray
        label.textAlignment = .left
        label.backgroundColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .right
        label.backgroundColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
private extension NewsListCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(decLabel)
        self.addSubview(dateLabel)
        
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        decLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(decLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        configureHierarchy()
    }
}
//MARK: - Action
extension NewsListCell {
    
    func configure(with model: NewsItems) {
        let titleWithoutHTML = UserDefinedFunction.shared.replacingOccurrences(model.title)
        titleLabel.text = titleWithoutHTML
        
        let decWithoutHTML = UserDefinedFunction.shared.replacingOccurrences(model.description)
        decLabel.text = decWithoutHTML
        
        let date = UserDefinedFunction.shared.dateFormatter(date: model.pubDate)
        dateLabel.text = date
    }
}
