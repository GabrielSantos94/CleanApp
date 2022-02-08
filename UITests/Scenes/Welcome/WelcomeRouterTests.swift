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

class WelcomeRouterTests: XCTestCase {
    
    func testGoToLoginCallsNavWithCorrectVC() {
        
        let (sut, navigationController) = makeSUT()
        
        sut.goToLogin()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is LoginViewController)
    }
    
    func testGoToSignUpCallsNavWithCorrectVC() {
        
        let (sut, navigationController) = makeSUT()
        
        sut.goToSignUp()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is SignUpViewController)
    }
}

extension WelcomeRouterTests {
    
    func makeSUT() -> (sut: WelcomeRouter, nav: NavigationController) {
        
        let navigationController = NavigationController()
        let loginFactorySpy = LoginFactorySpy()
        let signUpFactorySpy = SignUpFactorySpy()
        
        let sut = WelcomeRouter(
            navigationController: navigationController,
            loginFactory: loginFactorySpy.makeLogin,
            signUpFactory: signUpFactorySpy.makeSignUp
        )
        
        return (sut, navigationController)
    }
}

extension WelcomeRouterTests {
    class LoginFactorySpy {
        
        func makeLogin() -> LoginViewController {
            return LoginViewController.instantiate()
        }
    }
    
    class SignUpFactorySpy {
        
        func makeSignUp() -> SignUpViewController {
            return SignUpViewController.instantiate()
        }
    }
}
