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
    
    private let signUpFactoy: () -> SignUpViewController = {
        let alamofireAdapter = makeAlamofireAdapter()
        let remoteAddAccount = makeRemoteAddAccount(httpClient: alamofireAdapter)
        return makeSignupController(with: remoteAddAccount)
    }
    
    private let loginFactory: () -> LoginViewController = {
        let alamofireAdapter = makeAlamofireAdapter()
        let remoteAuthentication = makeRemoteAuthentication(httpClient: alamofireAdapter)
        return makeLoginController(authentication: remoteAuthentication)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = NavigationController()
        let welcomeRouter = WelcomeRouter(
            navigationController: navigationController,
            loginFactory: loginFactory,
            signUpFactory: signUpFactoy
        )
        
        let welcomeViewController = WelcomeViewController.instantiate()
        welcomeViewController.signUp = welcomeRouter.goToSignUp
        welcomeViewController.login = welcomeRouter.goToLogin
        
        navigationController.setRootViewController(welcomeViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

