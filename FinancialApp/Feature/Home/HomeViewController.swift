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

final class HomeViewController : UIViewController, UICollectionViewDelegate {
    private let disposeBag = DisposeBag()
    private let homeViewModel = HomeViewModel()
    //TODO: - 페이지 네이션 수정
    private var currentPage: [HomeSection: Int] = [:]
    private let inputTrigger = PublishSubject<Void>()
    
    let refresh = UIRefreshControl()
    let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    var dataSource : UICollectionViewDiffableDataSource<HomeSection, HomeItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setNavigation()
        configureView()
    }
}

extension HomeViewController {
    
    private func setNavigation() {
        self.view.backgroundColor = .black
        self.navigationController?.setNaviagtion(vc: self, title: "", backTitle: "", color: .white)
    }
    
    private func configureHierarchy() {
        self.view.addSubview(collectionView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(self.view.safeAreaInsets)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        //TODO: - 위치 조정
        setBinding()
        setBindView()
        setDataSource()
        
        self.inputTrigger.onNext(())
    }
    
    private func configureView() {
        refresh.tintColor = .lightGray
        refresh.addTarget(self, action: #selector(refreshEnding), for: .valueChanged)
        setCollectionView()
        configureHierarchy()
    }
}

private extension HomeViewController {
    //TODO: - 수정
    private func setBinding() {
        loadingIndicator.startAnimating()
        let input = HomeViewModel.Input(inputTrigger: inputTrigger.asObserver())
        let output = homeViewModel.transform(input: input)
        output.mainList.bind { Data in
            switch Data {
            case .success(let data):
                var snapShot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
                
                let chartItems = HomeItem.chart(data.chartData)
                let bannerSection = HomeSection.banner("")
                snapShot.appendSections([bannerSection])
                snapShot.appendItems([chartItems], toSection: bannerSection)
                
                
                let orderItems = data.orderBook.map { orderData in
                    return HomeItem.orderBook(orderData)
                }
                let cagtegorySection = HomeSection.category
                snapShot.appendSections([cagtegorySection])
                snapShot.appendItems(orderItems, toSection: cagtegorySection)
                
                let AdsItems = HomeItem.Ads("")
                let AdsSection = HomeSection.horizotional
                snapShot.appendSections([AdsSection])
                snapShot.appendItems([AdsItems], toSection: AdsSection)
                
                let newsItems = data.newsData.map { newsData in
                    return HomeItem.newsList(newsData)
                }
                let verticalSection = HomeSection.vertical
                snapShot.appendSections([verticalSection])
                snapShot.appendItems(newsItems, toSection: verticalSection)
                
                self.dataSource?.apply(snapShot)
                self.loadingIndicator.stopAnimating()
            case .failure(let error):
                //TODO: - 에러처리
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setBindView() {
        collectionView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let item = self.dataSource?.itemIdentifier(for: indexPath)
            switch item {
            case .chart(_):
                //TODO: - 수정
                print("")
            case .newsList(let content):
                if let url = URL(string: content.originallink) {
                    UIApplication.shared.open(url)
                }
            case .Ads(_):
                print("")
            case .orderBook(let orderData):
                self.navigationController?.pushViewController(OrderBookDetailViewController(coinData: orderData), animated: true)
            case .none:
                print("")
            }
        }).disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    @objc
    private func refreshEnding(_ sender: UIRefreshControl) {
        //TODO: - 60초 제한
        self.inputTrigger.onNext(())
        self.refresh.endRefreshing()
    }
    
}
