//
//  CryptoInputViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit
import RxSwift

final class CryptoInputViewController: UIViewController {
    private let inputTrigger = PublishSubject<Void>()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
    private var searchBar = UISearchBar()
    private var cryptos: [CryptoModel] = cryptoData
    private var filteredCryptos: [CryptoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension CryptoInputViewController {
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
        }
        
        filteredCryptos = cryptos
    }
    
    private func configureView() {
        self.setNavigation("관심등록")
        self.view.backgroundColor = .black
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "가상화폐 검색"
        searchBar.searchTextField.textColor = .white
        configureCollectionView()
        configureHierarchy()
    }
    
}

// MARK: - UICollectionView
extension CryptoInputViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(CryptoCell.self, forCellWithReuseIdentifier: "CryptoCell")
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2 - 12
        
        layout.itemSize = CGSize(width: itemWidth, height: 80)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCryptos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CryptoCell", for: indexPath) as? CryptoCell else {
            return UICollectionViewCell()
        }
        cell.configure(filteredCryptos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCrypto = filteredCryptos[indexPath.item]
        self.showInputDialog(for: selectedCrypto.korean_name) { }
    }
}

// MARK: - 검색 기능
extension CryptoInputViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCryptos = cryptos
        } else {
            filteredCryptos = cryptos.filter { $0.korean_name.lowercased().contains(searchText.lowercased()) }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
