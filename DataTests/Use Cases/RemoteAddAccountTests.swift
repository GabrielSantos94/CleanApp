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
    
    func test_add_should_complete_with_error_if_client_completes_with_error() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            
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
    
    func test_add_should_complete_with_account_if_client_completes_with_data() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        let expectedAccount = makeAccountModel()
        
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            
            switch result {
            case .success(let account):
                XCTAssertEqual(account, expectedAccount)
            case .failure:
                XCTFail("Expected success but receive \(result) instead")
            }
            
            expection.fulfill()
        }
        
        httpPostClientSpy.completeWithData(expectedAccount.toData()!)
        wait(for: [expection], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let expection = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            
            switch result {
            case .success:
                XCTFail("Expected error but receive \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            
            expection.fulfill()
        }
        
        httpPostClientSpy.completeWithData(Data("invalid_data".utf8))
        wait(for: [expection], timeout: 1)
    }
    
    func test_add_should_not_complete_with_error_if_sut_is_null() {
        
        let httpPostClientSpy = HttpPostClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: URL(string: "blabla.com")!, httpClient: httpPostClientSpy)
        var result: Result<AccountModel, DomainError>?
        
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpPostClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    
    func makeSUT(url: URL = URL(string: "blabla.com")!) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy) {
        
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpPostClientSpy)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }
        
        return (sut, httpPostClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "", email: "", password: "", passwordConfirmation: "")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "", name: "", email: "", password: "")
    }
    
    class HttpPostClientSpy: HttpPostClient {
        
        var urls: [URL] = []
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            self.completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            self.completion?(.success(data))
        }
    }
}
