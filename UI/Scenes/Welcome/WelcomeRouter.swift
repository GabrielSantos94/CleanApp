//
//  WelcomeRouter.swift
//  UI
//
//  Created by Gabriel Santos on 08/02/22.
//

import Foundation

public final class WelcomeRouter {
    
    private let navigationController: NavigationController
    private let loginFactory: () -> LoginViewController
    private let signUpFactory: () -> SignUpViewController
    
    public init(navigationController: NavigationController,
                loginFactory: @escaping () -> LoginViewController,
                signUpFactory: @escaping () -> SignUpViewController) {
        
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.signUpFactory = signUpFactory
    }
    
    public func goToLogin() {
        navigationController.pushViewController(loginFactory())
    }
    
    public func goToSignUp() {
        navigationController.pushViewController(signUpFactory())
    }
}
