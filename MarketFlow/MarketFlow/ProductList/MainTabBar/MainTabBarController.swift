//
//  MainTabBarController.swift
//  MarketFlow
//
//  Created by İrem Onart on 15.01.2025.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        
        // Gölgeyi ekliyoruz
        tabBar.layer.shadowColor = UIColor.black.cgColor // Gölge rengi
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2) // Gölgenin yönü (yukarı doğru)
        tabBar.layer.shadowOpacity = 0.3 // Gölgenin saydamlık seviyesi
        tabBar.layer.shadowRadius = 4 // Gölgenin bulanıklık derecesi
        tabBar.layer.masksToBounds = false // Gölgenin taşmasını engellemek için false yapılmalı
        // View controller'ları oluşturun
        let productListVC = ProductListViewController()
        let anotherVC = CartScreenViewController()  // Başka bir view controller, örneğin bir profil ekranı
        
        // View controller'ları tab bar'a ekleyin
        let productListNav = UINavigationController(rootViewController: productListVC)
        let anotherVCNav = UINavigationController(rootViewController: anotherVC)
        
        // Tab bar item'ları ekleyin
        productListVC.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "house"), tag: 0)
        anotherVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "cart"), tag: 1)
        
        // Tab bar controller'a ekleyin
        viewControllers = [productListNav, anotherVCNav]
    }
}
