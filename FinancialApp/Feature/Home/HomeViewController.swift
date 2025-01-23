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
    private let inputTrigger = PublishSubject<Void>()
    
    let refresh = UIRefreshControl()
    private let searchBar = UISearchBar()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 30)), type: .ballPulseSync, color: .white)
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
        //TODO: - 빼내기
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureHierarchy() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaInsets)
            make.top.equalTo(searchBar.snp.bottom).offset(24)
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
        searchBar.delegate = self
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
                
                let chartItems = data.chartData.map { data in
                    return HomeItem.chart(data)
                }
                let bannerSection = HomeSection.banner
                snapShot.appendSections([bannerSection])
                snapShot.appendItems(chartItems, toSection: bannerSection)
                
                var InfoData: [InfoDataModel] = []
                let datas = [data.greedData, data.loanData, data.exchange]
                //TODO: - 빼내기
                for data in datas {
                    if let data = data as? GreedModel,
                       let firstData = data.data.first {
                        InfoData.append(InfoDataModel(title: firstData.value, subTitle: firstData.value_classification, description: ""))
                    }
                    if let data = data as? [LoanModel],
                       let data = data.first, let loan = data.int_r, let date = data.sfln_intrc_nm {
                        InfoData.append(InfoDataModel(title: "\(loan)%", subTitle: "", description: date))
                    }
                    if let data = data as? [FinancialModel],
                       let model = data.first, let name = model.cur_nm, let unit = model.cur_unit,
                       let ttb = model.ttb, let tts = model.tts {
                        //TODO: - 연산 프로퍼티
                        InfoData.append(InfoDataModel(title: "환율", subTitle: "입금: 📥 \(ttb)₩\n출금: 📤 \(tts)₩", description: "\(name) \(unit)"))
                    }
                }
                let infoItems = InfoData.map { data in
                    return HomeItem.infoData(data)
                }
                let infoSection = HomeSection.info
                snapShot.appendSections([infoSection])
                snapShot.appendItems(infoItems, toSection: infoSection)
                
                let orderItems = data.orderBook.map { orderData in
                    return HomeItem.orderBook(orderData)
                }
                let cagtegorySection = HomeSection.category(title: "실시간 거래대금")
                snapShot.appendSections([cagtegorySection])
                snapShot.appendItems(orderItems, toSection: cagtegorySection)
                
                let AdsItems = HomeItem.Ads("")
                let AdsSection = HomeSection.horizotional
                snapShot.appendSections([AdsSection])
                snapShot.appendItems([AdsItems], toSection: AdsSection)
                
                let newsItems = data.newsData.map { newsData in
                    return HomeItem.newsList(newsData)
                }
                let verticalSection = HomeSection.vertical(title: "실시간 주요 뉴스")
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
            case .infoData(_):
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
