//
//  WelcomeRouterTests.swift
//  UITests
//
//  Created by Gabriel Santos on 08/02/22.
//

import XCTest
import UIKit

@testable import UI

public final class WelcomeRouter {
    
    private let navigationController: NavigationController
    private let loginFactory: () -> LoginViewController
    
    public init(navigationController: NavigationController, loginFactory: @escaping () -> LoginViewController) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
    }
    
    public func goToLogin() {
        navigationController.pushViewController(loginFactory())
    }
}

class WelcomeRouterTests: XCTestCase {
    
    func testGoToLoginCallsNavWithCorrectVC() {
        let navigationController = NavigationController()
        let loginFactorySpy = LoginFactorySpy()
        
        let sut = WelcomeRouter(
            navigationController: navigationController,
            loginFactory: loginFactorySpy.makeLogin
        )
        
        sut.goToLogin()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is LoginViewController)
    }
    
    class LoginFactorySpy {
        
        func makeLogin() -> LoginViewController {
            return LoginViewController.instantiate()
        }
    }
}
