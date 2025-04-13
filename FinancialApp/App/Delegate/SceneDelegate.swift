//
//  SceneDelegate.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import UIKit
import AppTrackingTransparency

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var networkMonitor: NetworkMonitorManagerType = NetworkMonitorManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        sleep(2)
        
        let rootDirection = Database.shared.isUser
        let vc = (rootDirection) ? TabBarController() : UINavigationController(rootViewController: OnboardingViewController())
        window?.rootViewController = vc
        window?.windowScene = scene
        window?.makeKeyAndVisible()
        
        networkMonitor.startMonitoring { [weak self] status in
            switch status {
            case .satisfied:
                self?.dismissErrorView(scene: scene)
            case .unsatisfied:
                self?.presentErrorView(scene: scene)
            default:
                break
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestPermission()
        }
    }
    
    private func requestPermission() {
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
    
    private func presentErrorView(scene: UIScene) {
        if let windowScene = scene as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                let errorViewController = ErrorViewController(viewModel: ErrorViewModel(notiType: .network), errorType: NSError())
                errorViewController.modalPresentationStyle = .overCurrentContext
                rootViewController.present(errorViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func dismissErrorView(scene: UIScene) {
        if let windowScene = scene as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                rootViewController.dismiss(animated: true)
            }
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

