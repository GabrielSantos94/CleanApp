//
//  LoginControllerTests.swift
//  MainTests
//
//  Created by Gabriel Santos on 23/12/21.
//

import XCTest
import Validation
import UI

@testable import Main

class LoginControllerTests: XCTestCase {

    func test_background_request_should_complete_on_main_thread() {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeLoginControllerWith(authentication: MainQueueDispatchDecorator(authenticationSpy))
        
        sut.loadViewIfNeeded()
        sut.login?(makeLoginViewModel())

        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            authenticationSpy.completeWithError(.unexpected)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        checkMemoryLeak(for: sut)
    }
    
    func test_signUp_compose_with_correct_validations() {
        let validations = makeLoginValidations()
        
        XCTAssertEqual(
            validations[0] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email")
        )
        
        XCTAssertEqual(
            validations[1] as! EmailValidation,
            EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy())
        )
        
        XCTAssertEqual(
            validations[2] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha")
        )
    }
}

extension LoginControllerTests {
    func makeSut() -> (sut: LoginViewController, authenticationSpy: AuthenticationSpy) {
        
        let authenticationSpy = AuthenticationSpy()
        let sut = makeLoginControllerWith(authentication: authenticationSpy)
        
        return (sut, authenticationSpy)
    }
}
