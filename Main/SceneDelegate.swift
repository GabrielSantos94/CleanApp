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
        
        let httpClient = makeAlamofireAdapter()
        let addAccount = makeRemoteAddAccount(httpClient: httpClient)
        
        let signupController = makeSignupController(with: addAccount)
        let nav = NavigationController(rootViewController: signupController)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

