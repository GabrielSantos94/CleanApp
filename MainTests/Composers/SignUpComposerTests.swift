//
//  SignUpComposerTests.swift
//  MainTests
//
//  Created by Gabriel Santos on 23/12/21.
//

import XCTest

@testable import Main


class SignUpComposerTests: XCTestCase {

    func test_background_request_should_complete_on_main_thread() {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeController(with: MainQueueDispatchDecorator(addAccountSpy))
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
}
