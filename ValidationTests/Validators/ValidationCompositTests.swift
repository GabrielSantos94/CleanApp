//
//  ValidationCompositTests.swift
//  ValidationTests
//
//  Created by Gabriel Santos on 03/01/22.
//

import XCTest

@testable import Validation

class ValidationCompositTests: XCTestCase {
    
    func test_validate_should_return_error_if_validation_fails() {
        let validationSpy = ValidationSpy()
        let sut = ValidationComposit(validations: [validationSpy])
        validationSpy.simulateError("Error 1")
        let errorMessage = sut.validate(data: ["name": "Gabriel"])
        XCTAssertEqual(errorMessage, "Error 1")
    }
    
    func test_validate_should_return_correct_error_message() {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let validationSpy3 = ValidationSpy()
        let sut = ValidationComposit(validations: [validationSpy, validationSpy2, validationSpy3])
        validationSpy2.simulateError("Error 2")
        validationSpy3.simulateError("Error 3")
        let errorMessage = sut.validate(data: ["name": "Gabriel"])
        XCTAssertEqual(errorMessage, "Error 2")
    }
    
    func test_validate_should_return_nil_if_validation_succeeds() {
        let validationSpy = ValidationSpy()
        let sut = ValidationComposit(validations: [validationSpy])
        let errorMessage = sut.validate(data: ["name": "Gabriel"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_call_validation_with_correct_data() {
        let validationSpy = ValidationSpy()
        let sut = ValidationComposit(validations: [validationSpy])
        let data = ["name": "Gabriel"]
        _ = sut.validate(data: data)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: data))
    }
}
