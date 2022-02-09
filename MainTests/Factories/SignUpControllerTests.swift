//
//  SignUpControllerTests.swift
//  MainTests
//
//  Created by Gabriel Santos on 23/12/21.
//

import XCTest
import Validation

@testable import Main

class SignUpControllerTests: XCTestCase {

    func test_background_request_should_complete_on_main_thread() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSignupControllerWith(addAccount: MainQueueDispatchDecorator(addAccountSpy))
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpViewModel())
        
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        checkMemoryLeak(for: sut)
    }
    
    func test_signUp_compose_with_correct_validations() {
        let validations = makeSignupValidations()
        
        XCTAssertEqual(
            validations[0] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome")
        )
        
        XCTAssertEqual(
            validations[1] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email")
        )
        
        XCTAssertEqual(
            validations[2] as! EmailValidation,
            EmailValidation(
                fieldName: "email",
                fieldLabel: "Email",
                emailValidator: EmailValidatorSpy()
            )
        )
        
        XCTAssertEqual(
            validations[3] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha")
        )
        
        XCTAssertEqual(
            validations[4] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar Senha")
        )
        
        XCTAssertEqual(
            validations[5] as! CompareFieldsValidation,
            CompareFieldsValidation(
                fieldName: "password",
                fieldNameToCompare: "passwordConfirmation",
                fieldLabel: "Confirmar Senha"
            )
        )
    }
}
