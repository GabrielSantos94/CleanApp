//
//  RemoteAddAccount.swift
//  RemoteAddAccount
//
//  Created by Gabriel Santos on 19/10/21.
//

import XCTest

class RemoteAddAccount {
    
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }
}

protocol HttpPostClient {
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {

    func test_() {
        let url = URL(string: "www.google.com")!
        let httpPostClientSpy = HttpPostClientSpy()
        
        let sut = RemoteAddAccount(url: url, httpClient: httpPostClientSpy)
        sut.add()
        
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
}

extension RemoteAddAccountTests {
    
    class HttpPostClientSpy: HttpPostClient {
        
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}
