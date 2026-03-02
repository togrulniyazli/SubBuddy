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
        
        let promoVC = UIViewController()
        promoVC.view.backgroundColor = .systemBackground
        promoVC.title = "Promo"
        
        let mySubVC = UIViewController()
        mySubVC.view.backgroundColor = .systemBackground
        mySubVC.title = "MySub"
        
        let profileVC = ProfileViewController()
        profileVC.view.backgroundColor = .systemBackground
        profileVC.title = "Profile"
        
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        promoVC.tabBarItem = UITabBarItem(
            title: "Promo",
            image: UIImage(systemName: "tag"),
            selectedImage: UIImage(systemName: "tag.fill")
        )
        
        mySubVC.tabBarItem = UITabBarItem(
            title: "MySub",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            homeVC,
            promoVC,
            mySubVC,
            profileVC
        ]
    }
}
