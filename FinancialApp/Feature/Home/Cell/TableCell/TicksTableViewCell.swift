//
//  TicksTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit

final class TicksTableViewCell: UITableViewCell {
    static let id: String = "TicksTableViewCell"
    private let titleLabel = UILabel()
    private let pageLabel = UILabel()
    private var currentPage: Int = 1
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())

    private var ticksData: [[AddTradesModel]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var showDialog: ((String?)->Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ data: [[AddTradesModel]]) {
        self.ticksData = data
    }
}

extension TicksTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
        self.addSubview(pageLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        
        titleLabel.text = "실시간 거래 정보"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        pageLabel.textColor = .white
        pageLabel.clipsToBounds = true
        pageLabel.layer.cornerRadius = 5
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = .darkGray
        pageLabel.font = .boldSystemFont(ofSize: 15)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

extension TicksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TicksCollectionViewCell.self, forCellWithReuseIdentifier: TicksCollectionViewCell.id)
    }
    
    private func setcollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: 70)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ticksData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicksCollectionViewCell.id, for: indexPath) as? TicksCollectionViewCell else { return UICollectionViewCell() }
        configurePage()
        cell.configure(with: ticksData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicksCollectionViewCell else { return }
        showDialog?(cell.titleLabel.text)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        currentPage = page + 1
        configurePage()
    }
    
    private func configurePage() {
        pageLabel.text = "\(currentPage)/\(ticksData.count/2 + ticksData.count%2)"
    }
}
