//
//  UITests.swift
//  UITests
//
//  Created by Gabriel Santos on 22/12/21.
//

import XCTest
import UIKit

@testable import UI

class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_at_start() {
        
        let sb = UIStoryboard(name: "SignUpViewController", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }

}
