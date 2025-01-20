//
//  SceneDelegate.swift
//  Beecher
//
//  Created by 정성윤 on 2024/03/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        //TODO: - 수정
        let vc2 = UINavigationController(rootViewController: HomeViewController())
        let vc3 = UINavigationController(rootViewController: HomeViewController())
        let vc4 = UINavigationController(rootViewController: HomeViewController())
        let tabVC = UITabBarController()
        tabVC.tabBar.backgroundColor = .darkGray.withAlphaComponent(0.2)
        tabVC.tabBar.clipsToBounds = true
        tabVC.tabBar.layer.cornerRadius = 20
        tabVC.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabVC.tabBar.tintColor = .white
        
        tabVC.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        guard let items = tabVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "chart.xyaxis.line")
        items[1].image = UIImage(systemName: "xmark")
        items[2].image = UIImage(systemName: "homekit")
        items[3].image = UIImage(systemName: "pencil")
        
        items[0].title = nil
        items[1].title = nil
        items[2].title = nil
        items[3].title = nil
        
        window?.rootViewController = tabVC
        window?.windowScene = scene
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

