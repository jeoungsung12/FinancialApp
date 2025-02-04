//
//  SceneDelegate.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import UIKit
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootDirection = Database.shared.isUser
        let vc = (rootDirection) ? TabBarController() : UINavigationController(rootViewController: OnboardingViewController())
        window?.rootViewController = vc
        window?.windowScene = scene
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestPermission()
        }
    }
    
    func requestPermission() {
        if #available(iOS 15.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("앱 추적 허용: Tracking authorized.")
                case .denied:
                    print("앱 추적 거부: Tracking denied.")
                case .notDetermined:
                    print("앱 추적 미결정: Tracking not determined.")
                case .restricted:
                    print("앱 추적 제한: Tracking restricted.")
                @unknown default:
                    print("앱 추적 알 수 없음: Unknown status.")
                }
            })
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

