//
//  EmailValidatorAdapterTests.swift
//  ValidationTests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
import Presentation
//@testable import Validation

public final class EmailValidatorAdapter: EmailValidator {
    private let patter = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: patter)
        
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
}

class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_email()  {
        
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: ""))
        XCTAssertFalse(sut.isValid(email: "bla@"))
        XCTAssertFalse(sut.isValid(email: "bla@bla"))
        XCTAssertFalse(sut.isValid(email: "bla@bla."))
        XCTAssertFalse(sut.isValid(email: "@bla.com"))
    }
}
