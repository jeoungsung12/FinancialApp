//
//  NewsListTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit

final class NewsListTableViewCell: UITableViewCell {
    static let id: String = "NewsListTableViewCell"
    private let titleLabel = UILabel()
    private var tableView = UITableView()

    var newsData: [NewsItems] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
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

extension NewsListTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.text = "실시간 주요 뉴스"
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        configureTableView()
        configureHierarchy()
    }
    
}

extension NewsListTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .black
        tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.id, for: indexPath) as? NewsListCell else { return UITableViewCell() }
        cell.configure(with: newsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
