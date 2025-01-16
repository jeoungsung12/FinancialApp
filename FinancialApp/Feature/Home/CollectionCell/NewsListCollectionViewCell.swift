//
//  NewsListCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation

final class NewsListCollectionViewCell : UICollectionViewCell {
    static let id = "NewsListCollectionViewCell"
    //MARK: - UI Components
    private let title : UILabel = {
        let label = UILabel()
        label.text = "📰 뉴스"
        label.textColor = .keyColor
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    //뉴스제목
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
    //뉴스기사
    private let decLabel : UITextView = {
        let label = UITextView()
        label.textColor = .gray
        label.textAlignment = .left
        label.isScrollEnabled = false
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    //뉴스 발행일
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
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
private extension NewsListCollectionViewCell {
    private func setLayout() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.keyColor.cgColor
        
        self.addSubview(title)
        self.addSubview(titleLabel)
        self.addSubview(decLabel)
        self.addSubview(dateLabel)
        
        title.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.leading.top.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        decLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
//MARK: - Action
extension NewsListCollectionViewCell {
    func configure(with model: NewsItems) {
        let titleWithoutHTML = model.title?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).removingHTMLEntities()
        titleLabel.text = "📢 \(titleWithoutHTML ?? "")"
        let decWithoutHTML = model.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).removingHTMLEntities()
        decLabel.text = decWithoutHTML
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: model.pubDate ?? "") {
            dateFormatter.dateFormat = "EEE, dd MMM yyyy"
            let formattedDate = dateFormatter.string(from: date)
            dateLabel.text = formattedDate
        } else {
            print("날짜를 변환하는 동안 문제가 발생했습니다.")
        }
    }
}
