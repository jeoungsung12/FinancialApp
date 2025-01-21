////
////  TotalSearchViewController.swift
////  Beecher
////
////  Created by 정성윤 on 2024/07/21.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//import SnapKit
//import UIKit
//import NVActivityIndicatorView
//
////Collection View Enum
//enum searchSection : Hashable {
//    case banner(String)
//    case horizotional
//    case vertical(String)
//}
//enum searchItem : Hashable {
//    case financialList(FinancialModel)
//    case loanList(LoanModel)
//    case searchList(SearchResult)
//}
//
//
//class TotalSearchViewController : UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UIScrollViewDelegate {
//    private var disposeBag = DisposeBag()
//    private let searchViewModel = TotalSearchViewModel()
//    private var coinData : [CoinDataWithAdditionalInfo] = []
//    private var orderData : [AddTradesModel] = []
////    private var currentPage: [Section: Int] = [:]
//    
//    //코인명
//    private var koreanName : [String] = []
//    private var englishName : [String] = []
//    private var marketName : [String] = []
//    
//    //MARK: UI Components
//    private var dataSource : UICollectionViewDiffableDataSource<searchSection, searchItem>?
//    private lazy var refresh : UIRefreshControl = {
//        let control = UIRefreshControl()
//        control.tintColor = .lightGray
//        control.addTarget(self, action: #selector(refreshEnding), for: .valueChanged)
//        return control
//    }()
//    //pageControl
//    private let pageControl : UIPageControl = {
//        let control = UIPageControl()
//        control.pageIndicatorTintColor = .lightGray
//        control.currentPageIndicatorTintColor = .darkGray
//        return control
//    }()
//    private let verticalLabel : UILabel = {
//        let label = UILabel()
//        label.textColor = .gray
//        label.textAlignment = .right
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        return label
//    }()
//    lazy var collectionView : UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
//        view.clipsToBounds = true
//        view.backgroundColor = .white
//        view.register(FinancialCollectionCell.self, forCellWithReuseIdentifier: FinancialCollectionCell.id)
//        view.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.id)
//        view.register(LoanCollectionViewCell.self, forCellWithReuseIdentifier: LoanCollectionViewCell.id)
//        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
//        return view
//    }()
////    private lazy var tapGesture : UITapGestureRecognizer = {
////        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
////        return gesture
////    }()
//    //검색 창
//    private let searchView : UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        view.layer.borderWidth = 1
//        view.frame = CGRect(x: 0, y: 0, width: 320, height: 35)
//        return view
//    }()
//    //검색 텍스트
//    private let searchText : UITextField = {
//        let text = UITextField()
//        text.textColor = .black
//        text.backgroundColor = .white
//        text.placeholder = "코인명(한/영/심볼) 입력"
//        text.textAlignment = .left
//        text.font = UIFont.systemFont(ofSize: 15)
//        text.frame = CGRect(x: 10, y: 3, width: 300, height: 30)
//        return text
//    }()
//    //검색 버튼
//    private let searchBtn : UIButton = {
//        let btn = UIButton()
//        btn.backgroundColor = .white
//        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//        btn.tintColor = .black
//        return btn
//    }()
//    private lazy var moveBtn : UIButton = {
//        let btn = UIButton()
//        btn.isEnabled = false
//        btn.clipsToBounds = true
//        btn.backgroundColor = .clear
//        btn.addTarget(self, action: #selector(moveBtnTapped), for: .touchUpInside)
//        return btn
//    }()
//    private let loadingIndicator : NVActivityIndicatorView = {
//        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballBeat, color: .black)
//        return view
//    }()
//    private let logoLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Bitcher"
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        return label
//    }()
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        setLayout()
//        setBinding()
//        setDataSource()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        disposeBag = DisposeBag()
//    }
//}
////MARK: - UI Layout
//extension TotalSearchViewController {
//    private func setLayout() {
//        self.title = "검색"
//        self.view.backgroundColor = .white
//        self.navigationItem.titleView = logoLabel
//        self.view.clipsToBounds = true
////        self.view.addGestureRecognizer(tapGesture)
//        
//        
//        self.searchText.delegate = self
//        self.searchView.addSubview(searchText)
//        self.searchView.addSubview(searchBtn)
//        self.view.addSubview(searchView)
//        searchText.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(10)
//            make.top.bottom.equalToSuperview().inset(5)
//            make.width.equalToSuperview().dividedBy(1.3)
//        }
//        searchBtn.snp.makeConstraints { make in
//            make.leading.equalTo(searchText.snp.trailing).offset(5)
//            make.trailing.top.bottom.equalToSuperview().inset(5)
//        }
//        searchView.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.top.equalToSuperview().inset(self.view.frame.height / 8)
//        }
//        
//        
//        self.collectionView.delegate = self
//        self.collectionView.refreshControl = refresh
//        
//        self.view.addSubview(collectionView)
//        self.view.addSubview(pageControl)
//        self.view.addSubview(loadingIndicator)
//        self.view.addSubview(verticalLabel)
//        self.view.addSubview(moveBtn)
//        verticalLabel.snp.remakeConstraints { make in
//            make.trailing.equalToSuperview().inset(20)
//            make.top.equalTo(self.searchView.snp.bottom).offset(30)
//        }
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(verticalLabel.snp.bottom).offset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        loadingIndicator.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(0)
//            make.height.equalTo(40)
//            make.center.equalToSuperview()
//        }
//        moveBtn.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        self.loadingIndicator.startAnimating()
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    @objc private func hideKeyboard() {
//        self.searchText.resignFirstResponder()
//    }
//}
////MARK: - setBinding
//extension TotalSearchViewController {
//    private func setBinding() {
//        searchViewModel.coinTrigger.onNext(())
//        searchViewModel.inputTrigger.onNext(())
//        searchViewModel.coinResult.bind(onNext: {[weak self] data in
//            guard let self = self else { return }
//            let market = data.compactMap { $0.market }
//            let koreanName = data.compactMap { $0.korean_name }
//            let englishName = data.compactMap { $0.english_name }
//            self.marketName = market
//            self.koreanName = koreanName
//            self.englishName = englishName
//        }).disposed(by: disposeBag)
//        searchViewModel.outputResult.bind(onNext: {[weak self] data in
//            guard let self = self else { return }
//            switch data {
//            case .success(let data):
//                var snapShot = NSDiffableDataSourceSnapshot<searchSection, searchItem>()
//                //환율 데이터
//                let financialItems = data.financialData.map { financialData in
//                    return searchItem.financialList(financialData)
//                }
//                if financialItems != [] {
//                    let bannerSection = searchSection.banner("💹 오늘의 환율")
//                    snapShot.appendSections([bannerSection])
//                    snapShot.appendItems(financialItems, toSection: bannerSection)
//                }
//                //대출 금리
//                let loanItems = data.loanData.map { loanData in
//                    return searchItem.loanList(loanData)
//                }
//                if loanItems != [] {
//                    let horizontalSection = searchSection.vertical("💸 대출 금리")
//                    snapShot.appendSections([horizontalSection])
//                    snapShot.appendItems(loanItems, toSection: horizontalSection)
//                }
//                self.dataSource?.apply(snapShot)
//                self.moveBtn.isEnabled = false
//                self.loadingIndicator.stopAnimating()
//            case .failure(let error):
//                print(error)
//                self.loadingIndicator.stopAnimating()
//            }
//        }).disposed(by: disposeBag)
//        
//        searchBtn.rx.tap
//            .subscribe { _ in
//                self.hideKeyboard()
//                if let text = self.searchText.text {
//                    if (self.marketName.contains(text) || self.koreanName.contains(text) || self.englishName.contains(text)) {
//                        self.loadingIndicator.startAnimating()
//                        self.searchViewModel.searchInputrigger.onNext((self.searchText.text ?? ""))
//                        self.searchText.text = nil
//                    } else { self.AlertError(title: "코인명(한/영/마켓) 확인", message: "⚠️ 코인명(한/영)을 다시 확인해 주세요") }
//                } else { self.AlertError(title: "코인명(한/영/마켓) 확인", message: "⚠️ 코인명(한/영)을 다시 확인해 주세요") }
//            }
//            .disposed(by: disposeBag)
//        searchViewModel.searchResult
//            .subscribe { coinData in
//                switch coinData {
//                case .success(let data):
//                    self.coinData = data.coinData //코인 데이터
//                    self.orderData = data.orderData //호가 데이터
//                    
//                    var snapShot = NSDiffableDataSourceSnapshot<searchSection,searchItem>()
//                    let searchItems = searchItem.searchList(data)
//                    let searchSection = searchSection.horizotional
//                    snapShot.appendSections([searchSection])
//                    snapShot.appendItems([searchItems], toSection: searchSection)
//                    
//                    self.dataSource?.apply(snapShot)
//                    self.moveBtn.isEnabled = true
//                    self.loadingIndicator.stopAnimating()
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//}
////MARK: - Set CollectionView
//private extension TotalSearchViewController {
//    //Set Collection View
//    private func createLayout() -> UICollectionViewCompositionalLayout {
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 14
//        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
//            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
//            
//            switch section {
//            case .banner:
//                return self?.createBannerSection()
//            case .horizotional:
//                return self?.createHorizontalSection()
//            case .vertical:
//                return self?.createVerticalSection()
//            default:
//                return self?.createBannerSection()
//            }
//        }, configuration: config)
//    }
//    private func createBannerSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 60, leading: 20, bottom: 40, trailing: 20)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPaging
//        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
//            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
//            self.pageControl.currentPage = currentPage
//        }
//        
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
//        section.boundarySupplementaryItems = [header]
//        
//        return section
//    }
//    private func createVerticalSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(270))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 4)
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPaging
//        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
//            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
//            self.verticalLabel.text = "🔜 \(currentPage+1) 페이지"
//        }
//        return section
//    }
//    private func createHorizontalSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .none
//        self.verticalLabel.text = nil
//        return section
//    }
//    private func setDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<searchSection,searchItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            switch itemIdentifier {
//            case .financialList(let financialData):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialCollectionCell.id, for: indexPath) as? FinancialCollectionCell
//                cell?.configure(with: financialData)
//                return cell ?? nil
//            case .loanList(let loanData):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoanCollectionViewCell.id, for: indexPath) as? LoanCollectionViewCell
//                cell?.configure(with: loanData)
//                return cell ?? nil
//            case .searchList(let searchData):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as? SearchCollectionViewCell
//                cell?.configure(with: searchData)
//                return cell ?? nil
//            }
//        })
//        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath -> UICollectionReusableView in
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderView.id, for: indexPath)
//            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
//            
//            switch section {
//            case .banner(let title):
//                (header as? SearchHeaderView)?.configure(title: title)
//            case .horizotional:
//                print("horizontinal")
//            case .vertical(let title):
//                (header as? SearchHeaderView)?.configure(title: title)
//            default:
//                print("Default")
//            }
//            return header
//        }
//    }
//}
////MARK: - Action
//extension TotalSearchViewController {
//    private func setAlert() {
//        let Alert = UIAlertController(title: "차트/호가 모아보기", message: nil, preferredStyle: .alert)
//        let Chart = UIAlertAction(title: "차트", style: .default) { _ in
//            self.navigationController?.pushViewController(MainDetailViewController(coinData: self.coinData), animated: true)
//        }
//        let Order = UIAlertAction(title: "호가", style: .default) { _ in
//            self.navigationController?.pushViewController(OrderBookDetailViewController(coinData: self.orderData), animated: true)
//        }
//        let Cancel = UIAlertAction(title: "취소", style: .destructive)
//        Alert.addAction(Chart)
//        Alert.addAction(Order)
//        Alert.addAction(Cancel)
//        self.present(Alert, animated: true)
//    }
//    private func AlertError(title : String, message : String) {
//        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let Ok = UIAlertAction(title: "확인", style: .default)
//        Alert.addAction(Ok)
//        self.present(Alert, animated: true)
//    }
//    @objc private func refreshEnding() {
//        self.searchViewModel.inputTrigger.onNext(())
//        self.refresh.endRefreshing()
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.pageControl.snp.remakeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(-scrollView.contentOffset.y+UIScreen.main.bounds.width-40)
//        }
//    }
//    @objc private func moveBtnTapped() {
//        self.setAlert()
//    }
//}
