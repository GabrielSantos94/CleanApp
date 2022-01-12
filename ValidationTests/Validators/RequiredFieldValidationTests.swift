//
//  RequiredFieldValidationTests.swift
//  ValidationTests
//
//  Created by Gabriel Santos on 03/01/22.
//

import XCTest
import Presentation

@testable import Validation

class RequiredFieldValidationTests: XCTestCase {
    
    func test_validate_should_return_error_if_field_is_not_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["name": "Gabriel"])
        
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
    
    func test_validate_should_return_error_with_correct_field() {
        let sut = makeSut(fieldName: "age", fieldLabel: "Idade")
        let errorMessage = sut.validate(data: ["name": "Gabriel"])
        
        XCTAssertEqual(errorMessage, "O campo Idade é obrigatório")
    }
    
    func test_validate_should_return_nil_if_field_is_not_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["email": "gabriel.jesus@email.com"])
        
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_nil_if_no_data_is_provided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: nil)
        
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
}

extension RequiredFieldValidationTests {
    
    func makeSut(fieldName: String, fieldLabel: String) -> Validation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut)
        return sut
    }
}
