//
//  CoinCollectionViewCell.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DGCharts
import Foundation
import GoogleMobileAds

final class AdsCollectionViewCell : UICollectionViewCell, GADBannerViewDelegate {
    static let id : String = "AdsCollectionViewCell"
    //MARK: - UI Components
    private let AdsView : GADBannerView = {
        let view = GADBannerView()
        view.backgroundColor = .clear
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI Layout
private extension AdsCollectionViewCell {
    private func configureHierarchy() {
        self.addSubview(AdsView)
        configureLayout()
    }
    
    private func configureLayout() {
        AdsView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        AdsView.clipsToBounds = true
        AdsView.layer.cornerRadius = 15
        configureHierarchy()
    }
}
//MARK: - Configure
extension AdsCollectionViewCell {
    public func configure(_ AdsString : String) {
        self.AdsView.adUnitID = "ca-app-pub-1155068737041268/1768586357"
        let request = GADRequest()
        self.AdsView.load(request)
        self.AdsView.delegate = self
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            bannerView.alpha = 1
        })
    }
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Failed to receive ad: \(error.localizedDescription)")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen: Ad is about to present a full screen view.")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDismissScreen: Ad is about to dismiss a full screen view.")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen: Ad has dismissed the full screen view.")
    }
    
    func bannerViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("bannerViewWillLeaveApplication: User clicked on an ad that will launch another application.")
    }
}
