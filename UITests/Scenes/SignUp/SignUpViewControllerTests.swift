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

class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_at_start() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingView() {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    func test_sut_implements_alertView() {
        XCTAssertNotNil(makeSut() as AlertView)
    }
    
    func test_save_button_calls_signUp_on_tap() {
        var signupViewModel: SignUpRequest?
        let signUpSpy: (SignUpRequest) -> Void = { signupViewModel = $0 }
        let sut = makeSut(signUpSpy: signUpSpy)
        
        sut.saveButton?.simulateTap()
        let name = sut.nameTextField?.text
        let email = sut.emailTextField?.text
        let password = sut.passwordTextField?.text
        let passwordConfirmation = sut.passwordConfirmationTextField?.text
        
        XCTAssertEqual(
            signupViewModel, SignUpRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
        )
    }
}

extension SignUpViewControllerTests {
    
    func makeSut(signUpSpy: ((SignUpRequest) -> Void)? = nil) -> SignUpViewController {
        let sut = SignUpViewController.instantiate()
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
