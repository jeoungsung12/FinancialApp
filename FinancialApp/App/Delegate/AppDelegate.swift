//
//  AppDelegate.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import UIKit
import AdSupport
import GoogleMobileAds
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestTrackingPermission()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    private func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("앱 추적 허용: Tracking authorized.")
                case .denied:
                    print("앱 추적 거부: Tracking denied.")
                case .restricted:
                    print("앱 추적 제한: Tracking restricted.")
                case .notDetermined:
                    print("앱 추적 미결정: Tracking not determined.")
                @unknown default:
                    print("앱 추적 알 수 없음: Unknown status.")
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
}

