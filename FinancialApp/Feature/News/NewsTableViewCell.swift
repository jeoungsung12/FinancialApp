//
//  NewsTableViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/07.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit
import Charts
import DGCharts
class NewsTableViewCell : UITableViewCell {
    //전체 뷰
    private let totalView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //뉴스제목
    private let titleLabel : UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        return label
    }()
    //뉴스기사
    private let decLabel : UITextView = {
        let label = UITextView()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        return label
    }()
    //뉴스 발행일
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
//MARK: - UI Layout
extension NewsTableViewCell {
    private func setupUI() {
        let contentView = self.contentView
        contentView.backgroundColor = .white
        contentView.snp.makeConstraints { make in
            make.height.equalTo(260)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        totalView.addSubview(titleLabel)
        totalView.addSubview(decLabel)
        totalView.addSubview(dateLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        decLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview().inset(10)
        }
        contentView.addSubview(totalView)
        totalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    func configure(with model: NewsItems) {
        let titleWithoutHTML = model.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).removingHTMLEntities()
        titleLabel.text = "📢 \(titleWithoutHTML)"
        let decWithoutHTML = model.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).removingHTMLEntities()
        decLabel.text = decWithoutHTML
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: model.pubDate) {
            dateFormatter.dateFormat = "EEE, dd MMM yyyy"
            let formattedDate = dateFormatter.string(from: date)
            dateLabel.text = formattedDate
        } else {
            print("날짜를 변환하는 동안 문제가 발생했습니다.")
        }
    }
}
