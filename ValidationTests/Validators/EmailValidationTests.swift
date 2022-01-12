//
//  EmailValidationTests.swift
//  ValidationTests
//
//  Created by Gabriel Santos on 03/01/22.
//

import XCTest

@testable import Validation

class EmailValidationTests: XCTestCase {
    
    func test_validate_should_return_error_if_email_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid_email@gmail.com"])
        
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
    }
    
    func test_validate_should_return_error_if_email_with_correct_field_label() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = EmailValidation(fieldName: "email", fieldLabel: "Email2", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid_email@gmail.com"])
        
        XCTAssertEqual(errorMessage, "O campo Email2 é inválido")
    }
    
    func test_validate_should_return_nil_if_valid_email_is_provided() {
        let sut = EmailValidation(fieldName: "email", fieldLabel: "Email2", emailValidator: EmailValidatorSpy())
        let errorMessage = sut.validate(data: ["email": "valid_email@gmail.com"])
        
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_nil_if_invalid_data_is_provided() {
        let sut = EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy())
        let errorMessage = sut.validate(data: nil)
        
        XCTAssertEqual(errorMessage, "O campo Email é inválido")
    }
}
