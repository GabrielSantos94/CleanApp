//
//  SignUpIntegrationTests.swift
//  MainTests
//
//  Created by Gabriel Santos on 23/12/21.
//

import XCTest

@testable import Main


class SignUpIntegrationTests: XCTestCase {

    func test_ui_presentation_integration() {
        let sut = SignUpComposer.composeController(with: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
