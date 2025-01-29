//
//  TabBarController.swift
//  FinancialApp
//
//  Created by 정성윤 on 1/29/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension TabBarController {
    
    private func configure() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: HeartViewController())
        let vc3 = UINavigationController(rootViewController: HeartViewController())
        let vc4 = UINavigationController(rootViewController: MyPageViewController())
        
        self.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "chart.xyaxis.line")
        items[1].image = UIImage(systemName: "homekit")
        items[2].image = UIImage(systemName: "heart")
        items[3].image = UIImage(systemName: "person")
        
        items[0].title = nil
        items[1].title = nil
        items[2].title = nil
        items[3].title = nil
           
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        appearance.configureWithOpaqueBackground()
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.selectedIndex = 0
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkGray
    }
    
}
