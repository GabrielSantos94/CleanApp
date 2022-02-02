//
//  RemoteAuthenticationTests.swift
//  DataTests
//
//  Created by Gabriel Santos on 02/02/22.
//

import Foundation
import Data
import XCTest

class RemoteAuthenticationTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSUT(url: url)
        sut.auth()
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
}

extension RemoteAuthenticationTests {
    
    func makeSUT(url: URL = URL(string: "blabla")!) -> (sut: RemoteAuthentication, httpPostClientSpy: HttpPostClientSpy) {
        
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAuthentication(url: url, httpClient: httpPostClientSpy)
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpPostClientSpy)
        
        return (sut, httpPostClientSpy)
    }
}
