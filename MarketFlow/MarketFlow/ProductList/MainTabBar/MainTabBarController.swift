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
        let cartVC = CartScreenViewController()  // Başka bir view controller, örneğin bir profil ekranı
        let favoritesVC = FavoritesViewController()
        let favoritesVm = FavoritesViewModel()
        favoritesVC.viewModel = favoritesVm
        
        // View controller'ları tab bar'a ekleyin
        let productListNav = UINavigationController(rootViewController: productListVC)
        let cartVCNav = UINavigationController(rootViewController: cartVC)
        let favoritesVCNav = UINavigationController(rootViewController: favoritesVC)
        
        // Tab bar item'ları ekleyin
        productListVC.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "house"), tag: 0)
        cartVCNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        favoritesVCNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 3)
        
        // Tab bar controller'a ekleyin
        viewControllers = [productListNav, cartVCNav, favoritesVCNav]
    }
}
