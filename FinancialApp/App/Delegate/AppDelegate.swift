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
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        //앱 추적 허용
        self.requestIDEA()
        
        //구글 광고 초기화
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    private func requestIDEA() {
        ATTrackingManager.requestTrackingAuthorization { status in
            print("앱 추적 허용 : \(status)")
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

