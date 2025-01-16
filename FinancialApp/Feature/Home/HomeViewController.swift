//
//  HomeViewController.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Foundation
import NVActivityIndicatorView
//Collection View Enum
enum Section : Hashable {
    case banner(String)
    case category
    case horizotional
    case vertical
}
enum Item : Hashable {
    case newsList(NewsItems)
    case category(CategoryList)
    case Ads(String)
    case orderBook([AddTradesModel])
}

final class HomeViewController : UIViewController, UICollectionViewDelegate {
    private let disposeBag = DisposeBag()
    private let homeViewModel = HomeViewModel()
    private var currentPage: [Section: Int] = [:]
    private let inputTrigger = PublishSubject<Void>()
    //MARK: - UI Components
    //refresh
    private lazy var refresh : UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .lightGray
        control.addTarget(self, action: #selector(refreshEnding), for: .valueChanged)
        return control
    }()
    //pageControl
    private let pageControl : UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .darkGray
        return control
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .keyColor)
        return view
    }()
    //타이틀
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcher"
        label.textColor = .keyColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    //horizontal Layer page
    private let verticalLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    lazy var collectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.register(NewsListCollectionViewCell.self, forCellWithReuseIdentifier: NewsListCollectionViewCell.id)
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        view.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: AdsCollectionViewCell.id)
        view.register(OrderBookCollectionViewCell.self, forCellWithReuseIdentifier: OrderBookCollectionViewCell.id)
        return view
    }()
    private var dataSource : UICollectionViewDiffableDataSource<Section, Item>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setBindView()
        setDataSource()
        setNavigation()
        
        //초기 데이터 로딩
        self.inputTrigger.onNext(())
    }
}
//MARK: - UI Navigation
private extension HomeViewController {
    private func setNavigation() {
        self.title = "메인"
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = titleLabel
    }
}
//MARK: - UI Layout
private extension HomeViewController {
    private func setLayout() {
        self.collectionView.delegate = self
        self.collectionView.refreshControl = refresh
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(verticalLabel)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }
        self.loadingIndicator.startAnimating()
    }
    //Set Collection View
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 20, bottom: 40, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            self.pageControl.currentPage = currentPage
        }
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return section
    }
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(270))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            if currentPage + 1 == 5 {
                self.verticalLabel.text = "🔚 \(currentPage+1) / 5"
            }else{
                self.verticalLabel.text = "🔜 \(currentPage+1) / 5"
            }
        }
        
        return section
    }
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .newsList(let newsData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsListCollectionViewCell.id, for: indexPath) as? NewsListCollectionViewCell
                cell?.configure(with: newsData)
                return cell ?? nil
            case .category(let categoryList):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell
                cell?.configure(btnImage: categoryList.btnImage, btnLabel: categoryList.btnLabel)
                return cell ?? nil
            case .Ads(let AdsString):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.id, for: indexPath) as? AdsCollectionViewCell
                cell?.configure(AdsString)
                return cell ?? nil
            case .orderBook(let orderData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBookCollectionViewCell.id, for: indexPath) as? OrderBookCollectionViewCell
                cell?.configure(with: orderData)
                return cell ?? nil
            }
        })
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .banner(let title):
                (header as? HeaderView)?.configure(title: title)
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
//MARK: - Binding
private extension HomeViewController {
    private func setBinding() {
        let input = HomeViewModel.Input(inputTrigger: inputTrigger.asObserver())
        let output = homeViewModel.transform(input: input)
        output.mainList.bind { Data in
            switch Data {
            case .success(let data):
                var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
                //뉴스 데이터
                let newsItems = data.newsData.map { newsData in
                    return Item.newsList(newsData)
                }
                let bannerSection = Section.banner("Welcome,\n 코인에 대한 정보를 확인해 보세요!")
                snapShot.appendSections([bannerSection])
                snapShot.appendItems(newsItems, toSection: bannerSection)
                //카테고리
                let categoryItems = data.category.map { categoryData in
                    return Item.category(categoryData)
                }
                let categorySection = Section.category
                snapShot.appendSections([categorySection])
                snapShot.appendItems(categoryItems, toSection: categorySection)
                
                //MARK: - 구글 광고
                let AdsItems = Item.Ads("")
                let AdsSection = Section.horizotional
                snapShot.appendSections([AdsSection])
                snapShot.appendItems([AdsItems], toSection: AdsSection)
                
                //코인 호가
                let orderItems = data.orderBook.map { orderData in
                    return Item.orderBook(orderData)
                }
                let orderSection = Section.vertical
                snapShot.appendSections([orderSection])
                snapShot.appendItems(orderItems, toSection: orderSection)
                
                self.pageControl.numberOfPages = newsItems.count
                self.dataSource?.apply(snapShot)
                self.loadingIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    private func setBindView() {
        //컬렉션 뷰 선택
        collectionView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let item = self.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .newsList(let content):
                if let url = URL(string: content.originallink ?? "") {
                    UIApplication.shared.open(url)
                }
            case .category(let category):
                switch category.btnLabel {
                case "Ai분석":
                    self.navigationController?.pushViewController(AiViewController(), animated: true)
                case "호가":
                    self.navigationController?.pushViewController(OrderBookViewController(), animated: true)
                case "차트":
                    self.navigationController?.pushViewController(MainViewController(), animated: true)
                case "뉴스":
                    self.navigationController?.pushViewController(NewsViewController(), animated: true)
                default:
                    print("Category - default")
                }
            case .Ads(_):
                print("GooleAdsMob")
            case .orderBook(let orderData):
                self.navigationController?.pushViewController(OrderBookDetailViewController(coinData: orderData), animated: true)
            default:
                print("default")
            }
        }).disposed(by: disposeBag)
    }
}
//MARK: - Action
extension HomeViewController {
    @objc private func refreshEnding() {
        self.inputTrigger.onNext(())
        self.refresh.endRefreshing()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(-scrollView.contentOffset.y+UIScreen.main.bounds.width-40)
        }
        self.verticalLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(-scrollView.contentOffset.y+UIScreen.main.bounds.width+170)
        }
    }
}
