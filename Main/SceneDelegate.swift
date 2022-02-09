//
//  SceneDelegate.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import UIKit
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = NavigationController()
        let welcomeViewController = makeWelcomeController(navigationController: navigationController)
        
        navigationController.setRootViewController(welcomeViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

