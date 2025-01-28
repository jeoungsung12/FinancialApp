//
//  AdsTableViewCell.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class AdsTableViewCell: UITableViewCell, GADBannerViewDelegate {
    static let id: String = "AdsTableViewCell"
    private let AdsView : GADBannerView = {
        let view = GADBannerView()
        view.backgroundColor = .clear
        return view
    }()
    
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

//MARK: - UI Layout
private extension AdsTableViewCell {
    private func configureHierarchy() {
        self.addSubview(AdsView)
        configureLayout()
    }
    
    private func configureLayout() {
        AdsView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.verticalEdges.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        configure()
    }
    
    private func configureView() {
        self.backgroundColor = .black
        AdsView.clipsToBounds = true
        AdsView.layer.cornerRadius = 15
        configureHierarchy()
    }
}
//MARK: - Configure
extension AdsTableViewCell {
    private func configure() {
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
