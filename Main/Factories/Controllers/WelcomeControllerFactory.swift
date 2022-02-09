//
//  LoginControllerFactory.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import UI
import UIKit

public func makeWelcomeController(navigationController: NavigationController) -> WelcomeViewController {
    let welcomeRouter = WelcomeRouter(
        navigationController: navigationController,
        loginFactory: makeLoginController,
        signUpFactory: makeSignupController
    )
    
    let welcomeViewController = WelcomeViewController.instantiate()
    welcomeViewController.signUp = welcomeRouter.goToSignUp
    welcomeViewController.login = welcomeRouter.goToLogin
    
    return welcomeViewController
}

