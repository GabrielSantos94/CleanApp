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

    func test_auth_should_call_httpClient_with_correct_url() {
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSUT(url: url)
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel) { _ in () }
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_auth_should_call_httpClient_with_correct_data() {
        let (sut, httpPostClientSpy) = makeSUT()
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel) { _ in () }
        XCTAssertEqual(httpPostClientSpy.data, authenticationModel.toData())
    }
    
    func test_auth_should_complete_with_error_if_client_completes_with_error() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        sut.auth(authenticationModel: makeAuthenticationModel()) { result in
            
            switch result {
            case .success:
                XCTFail("Expected error but receive \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            
            expection.fulfill()
        }
        httpPostClientSpy.completeWithError(.noConnectivity)
        wait(for: [expection], timeout: 1)
    }
    
    func test_auth_should_complete_with_email_in_use_error_if_client_completes_with_unauthorized() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        sut.auth(authenticationModel: makeAuthenticationModel()) { result in
            
            switch result {
            case .success:
                XCTFail("Expected error but receive \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .sessionExpired)
            }
            
            expection.fulfill()
        }
        httpPostClientSpy.completeWithError(.unauthorized)
        wait(for: [expection], timeout: 1)
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
