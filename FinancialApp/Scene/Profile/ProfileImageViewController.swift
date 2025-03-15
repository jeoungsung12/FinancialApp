//
//  ProfileImageViewController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private let profileButton = CustomProfileButton(120, true)
    
    var returnImage: ((UIImage?) -> Void)?
    var profileImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

//MARK: - Configure UI
extension ProfileImageViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileButton.snp.bottom).offset(36)
        }
    }
    
    private func configureView() {
        self.setNavigation("프로필 이미지 설정")
        self.view.backgroundColor = .black
        
        profileButton.isUserInteractionEnabled = false
        profileButton.profileImage.image = profileImage
        
        backAction()
        configureCollectionView()
        configureHierarchy()
    }
}

//MARK: - Action
extension ProfileImageViewController {
    
    private func backAction() {
        self.navigationItem.backAction = UIAction{ [weak self] _ in
            guard let self = self else { return }
            self.returnImage?(self.profileButton.profileImage.image)
            self.pop()
        }
    }
    
}


//MARK: - CollectionView
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing = 12
        let width = (Int(UIScreen.main.bounds.width) - (spacing * 5)) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileData.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        let image = UIImage(named: ProfileData.allCases[indexPath.row].rawValue)
        cell.configure(image)
        cell.profileButton.containerView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        cell.isSelected.toggle()
        profileButton.profileImage.image = cell.profileButton.profileImage.image
    }
    
}
