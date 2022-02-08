//
//  UITests.swift
//  UITests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
import UIKit

@testable import UI

class WelcomeViewControllerTests: XCTestCase {
    
    func test_login_button_calls_login_on_tap() {
        let (sut, buttonSpy) = makeSut()
        sut.loginButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
    
    func test_signup_button_calls_signup_on_tap() {
        let (sut, buttonSpy) = makeSut()
        sut.signUpButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    
    func makeSut() -> (sut: WelcomeViewController, buttonSpy: ButtonSpy) {
        let buttonSpy = ButtonSpy()
        let sut = WelcomeViewController.instantiate()
        sut.login = buttonSpy.onClick
        sut.signUp = buttonSpy.onClick
        sut.loadViewIfNeeded()
        return (sut, buttonSpy)
    }
    
    class ButtonSpy {
        var clicks = 0
        func onClick() {
            clicks += 1
        }
    }
}
