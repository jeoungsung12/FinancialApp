//
//  rewardHelper.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/28.
//
import Foundation
import GoogleMobileAds

class RewardedHelper: NSObject, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    private var dismiss : Bool = false
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-1155068737041268/1597195968", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load reward ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
        }
    }
    func showRewardedAd(viewController: UIViewController) {
        self.loadRewardedAd()
        if rewardedAd != nil {
            rewardedAd!.present(fromRootViewController: viewController, userDidEarnRewardHandler: {
                _ = self.rewardedAd!.adReward
            })
        } else {
            print("RewardedAd wasn't ready")
        }
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.dismiss = true
    }
}
