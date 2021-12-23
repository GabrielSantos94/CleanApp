//
//  EmailValidatorAdapterTests.swift
//  ValidationTests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
@testable import Validation

class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_email()  {
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: ""))
        XCTAssertFalse(sut.isValid(email: "bla@"))
        XCTAssertFalse(sut.isValid(email: "bla@bla"))
        XCTAssertFalse(sut.isValid(email: "bla@bla."))
        XCTAssertFalse(sut.isValid(email: "@bla.com"))
    }
    
    func test_valid_email()  {
        let sut = EmailValidatorAdapter()
        XCTAssertTrue(sut.isValid(email: "gabriel@hotmail.com"))
        XCTAssertTrue(sut.isValid(email: "gabriel@hotmail.com.br"))
        XCTAssertTrue(sut.isValid(email: "gabriel@gmail.com"))
    }
}
