//
//  RemoteAddAccount.swift
//  RemoteAddAccount
//
//  Created by Gabriel Santos on 19/10/21.
//

import Domain
import XCTest

class RemoteAddAccount {
    
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }
}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}

class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {
        
        let addAccountModel = makeAddAccountModel()
        let url = URL(string: "blabla.com")!
        
        let (sut, httpPostClientSpy) = makeSUT(url: url)
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        
        let (sut, httpPostClientSpy) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)
        let data = try! JSONEncoder().encode(addAccountModel)
        
        XCTAssertEqual(httpPostClientSpy.data, data)
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
        
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
