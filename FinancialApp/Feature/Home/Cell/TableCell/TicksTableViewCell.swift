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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())

    var ticksData: [[AddTradesModel]] = [] {
        didSet {
            collectionView.reloadData()
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

extension TicksTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        
        titleLabel.text = "실시간 거래 정보"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

extension TicksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        let width = UIScreen.main.bounds.width - 12
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
        cell.configure(with: ticksData[indexPath.row])
        return cell
    }
}
