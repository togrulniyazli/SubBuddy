//
//  SceneDelegate.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 08.02.26.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static var shared: SceneDelegate?

    var window: UIWindow?
    private let authService = AuthService.shared

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        Self.shared = self

        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        if let user = Auth.auth().currentUser {

                    user.reload { [weak self] _ in
                        guard let self else { return }

                        if user.isEmailVerified {
                            self.switchToMainTab()
                        } else {
                            self.switchToSignIn()
                        }
                    }

                } else {

                    let navController = UINavigationController(rootViewController: OpenerViewController())
                    window?.rootViewController = navController
                }
    }


    func switchToMainTab() {
        let tabBar = MainTabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

    func switchToSignIn() {
        let nav = UINavigationController(rootViewController: SignInViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
