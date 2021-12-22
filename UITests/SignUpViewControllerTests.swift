//
//  UITests.swift
//  UITests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
import UIKit
import Presentation

@testable import UI

class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_at_start() {
        let sut = makeStoryboard()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_sut_implements_loadingView() {
        let sut = makeStoryboard()
        XCTAssertNotNil(sut as LoadingView)
    }
}

extension SignUpViewControllerTests {
    
    func makeStoryboard() -> SignUpViewController {
        let sb = UIStoryboard(name: "SignUpViewController", bundle: Bundle(for: SignUpViewController.self))
        return sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
    }
}
