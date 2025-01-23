//
//  HomeVC + Extension.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/20/25.
//

import UIKit

//MARK: CollectioinView
extension HomeViewController {
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.refreshControl = refresh
        collectionView.backgroundColor = .black
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.id)
        collectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: AdsCollectionViewCell.id)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.id)
        collectionView.register(TicksCollectionViewCell.self, forCellWithReuseIdentifier: TicksCollectionViewCell.id)
        collectionView.register(NewsListCollectionViewCell.self, forCellWithReuseIdentifier: NewsListCollectionViewCell.id)
        //        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .info:
                return self?.createInfoSection()
            case .category:
                return self?.createCategorySection()
            case .horizotional:
                return self?.createHorizontalSection()
            case .vertical:
                return self?.createVerticalSection()
            default:
                return self?.createBannerSection()
            }
        }, configuration: config)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 24, bottom: 4, trailing: 24)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 24, bottom: 4, trailing: 24)
        group.interItemSpacing = .fixed(24)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(340))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0)
        return section
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection,HomeItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .chart(chartModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.id, for: indexPath) as? ChartCell
                cell?.configure([chartModel], indexPath.row+1)
                return cell
            case let .infoData(infoData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id, for: indexPath) as? InfoCollectionViewCell
                cell?.configure(model: infoData, index: indexPath.row)
                return cell
            case let .newsList(newsData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsListCollectionViewCell.id, for: indexPath) as? NewsListCollectionViewCell
                cell?.configure(with: newsData)
                return cell
            case let  .Ads(AdsString):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.id, for: indexPath) as? AdsCollectionViewCell
                cell?.configure(AdsString)
                return cell
            case let .orderBook(orderData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicksCollectionViewCell.id, for: indexPath) as? TicksCollectionViewCell
                cell?.configure(with: orderData)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .banner:
//                (header as? HeaderView)?.configure(title: title)
                print("banner")
            case .info:
                print("info")
            case .category:
                print("category")
            case .horizotional:
                print("horizontinal")
            case .vertical:
                print("vertical")
            default:
                print("Default")
            }
            return header
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
}
