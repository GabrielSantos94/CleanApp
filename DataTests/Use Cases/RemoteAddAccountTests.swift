//
//  RemoteAddAccount.swift
//  RemoteAddAccount
//
//  Created by Gabriel Santos on 19/10/21.
//

import Domain
import Data
import XCTest

class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        
        let addAccountModel = makeAddAccountModel()
        let url = URL(string: "blabla.com")!
        
        let (sut, httpPostClientSpy) = makeSUT(url: url)
        sut.add(addAccountModel: addAccountModel) { _ in }
        
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in }
        
        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_fails() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { error in
            XCTAssertEqual(error, .unexpected)
            expection.fulfill()
        }
        httpPostClientSpy.completeWithError(.noConnectivity)
        wait(for: [expection], timeout: 1)
    }
}

extension RemoteAddAccountTests {
    
    func makeSUT(url: URL = URL(string: "blabla.com")!) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy) {
        
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpPostClientSpy)
        
        return (sut, httpPostClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "", email: "", password: "", passwordConfirmation: "")
    }
    
    class HttpPostClientSpy: HttpPostClient {
        
        var urls: [URL] = []
        var data: Data?
        var completion: ((HttpError) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            self.completion?(error)
        }
    }
}
