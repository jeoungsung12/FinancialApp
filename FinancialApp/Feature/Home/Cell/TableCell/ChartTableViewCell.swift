//
//  ChartTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit
import Toast

final class ChartTableViewCell: UITableViewCell {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())
    static let id: String = "ChartTableViewCell"
    private let pageLabel = UILabel()
    private var currentPage: Int = 1
    
    var coinData: [[CandleModel]] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var heartTapped: (()->Void)?
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

extension ChartTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(pageLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(280)
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-24)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        pageLabel.textColor = .white
        pageLabel.clipsToBounds = true
        pageLabel.layer.cornerRadius = 5
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = .darkGray
        pageLabel.font = .boldSystemFont(ofSize: 15)
        
        configureCollectionView()
        configureHierarchy()
        configureHierarchy()
    }
    
}

extension ChartTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.id)
    }
    
    private func setcollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: width * 0.7)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.id, for: indexPath) as? ChartCell else { return UICollectionViewCell() }
        configurePage()
        cell.configure(coinData[indexPath.item])
        cell.heartTapped = { [weak self] type in
            guard let self = self else { return }
            self.heartTapped?()
            switch type {
            case .success:
                self.customMakeToast(ToastModel(title: nil, message: "찜하기 성공🎁, 목록을 확인하세요!"), HomeViewController(), .center)
            case .failure:
                self.customMakeToast(ToastModel(title: nil, message: "찜하기 📭 목록에서 삭제되었습니다!"), HomeViewController(), .center)
            }
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        currentPage = page + 1
        configurePage()
    }
    
    private func configurePage() {
        pageLabel.text = "\(currentPage)/\(coinData.count)"
    }
    
}
