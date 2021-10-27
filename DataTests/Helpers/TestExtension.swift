//
//  TestExtension.swift
//  DataTests
//
//  Created by Gabriel Santos on 27/10/21.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance)
        }
    }
}
