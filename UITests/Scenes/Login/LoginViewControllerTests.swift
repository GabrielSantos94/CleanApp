//
//  UITests.swift
//  UITests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
import UIKit
import Presentation

@testable import UI

class LoginViewControllerTests: XCTestCase {

    func test_loading_is_hidden_at_start() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingView() {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    func test_sut_implements_alertView() {
        XCTAssertNotNil(makeSut() as AlertView)
    }
    
    func test_login_button_calls_login_on_tap() {
        var loginViewModel: LoginRequest?
        let loginViewModelSpy: (LoginRequest) -> Void = { loginViewModel = $0 }
        let sut = makeSut(loginSpy: loginViewModelSpy)
        
        sut.loginButton?.simulateTap()
        let email = sut.emailTextField?.text
        let password = sut.passwordTextField?.text
        
        XCTAssertEqual(loginViewModel, LoginRequest(email: email, password: password))
    }
}

extension LoginViewControllerTests {
    
    func makeSut(loginSpy: ((LoginRequest) -> Void)? = nil) -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.login = loginSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
