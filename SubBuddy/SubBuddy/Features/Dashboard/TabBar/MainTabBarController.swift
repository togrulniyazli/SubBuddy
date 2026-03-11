//
//  MainTabBarController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 15.02.26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let primaryColor = UIColor(named: "appPrimaryColor") ?? .systemRed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tabBar.tintColor = primaryColor
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
    }
    
    private func setupTabs() {
        
        let homeVC = OverviewViewController()
        homeVC.view.backgroundColor = .systemBackground
        homeVC.title = "Home"
        let promoVC = PromoViewController()
        let mySubVC = MySubViewController()
        let profileVC = ProfileViewController()
        profileVC.view.backgroundColor = .systemBackground
        profileVC.title = "Profile"
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let promoNav = UINavigationController(rootViewController: promoVC)
        let mySubNav = UINavigationController(rootViewController: mySubVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        promoNav.tabBarItem = UITabBarItem(
            title: "Promo",
            image: UIImage(systemName: "tag"),
            selectedImage: UIImage(systemName: "tag.fill")
        )
        
        mySubNav.tabBarItem = UITabBarItem(
            title: "MySub",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            homeNav,
            promoNav,
            mySubNav,
            profileNav
        ]
    }
}
