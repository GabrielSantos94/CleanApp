//
//  InfraTests.swift
//  InfraTests
//
//  Created by Gabriel Santos on 09/11/21.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        
        session.request(
            url, method: .post,
            parameters: data?.toJSON(),
            encoding: JSONEncoding.default
        ).responseData { dataResponse in
            
            guard dataResponse.response?.statusCode != nil else {
                return completion(.failure(.noConnectivity))
            }
            
            switch dataResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                completion(.failure(.noConnectivity))
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {

    func test_post_should_make_request_with_valid_url_and_method() throws {
        let url = makeURL()
        
        testRequestFor(url: url, data: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }
    
    func test_post_should_complete_with_error_on_all_invalid_cases() {
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: makeHTTPResponse(), error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: makeHTTPResponse(), error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: makeHTTPResponse(), error: nil))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
}

extension AlamofireAdapterTests {
    
    func makeSut() -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut)
        return sut
    }
    
    func testRequestFor(url: URL = makeURL(), data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.post(to: url, with: data) { _ in exp.fulfill() }
        
        var request: URLRequest?
        URLProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expect(expectedResult: Result<Data, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?)) {
        
        let (data, response, error) = stub
        
        let sut = makeSut()
        URLProtocolStub.simulate(data: data, response: response, error: error)
        
        let exp = expectation(description: "waiting")
        sut.post(to: makeURL(), with: makeValidData()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success(let expectedSuccess), .success(let receivedSuccess)):
                XCTAssertEqual(expectedSuccess, receivedSuccess)
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError)
            default:
                XCTFail("Expected \(expectedResult) but we got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class URLProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest)-> Void)?
    
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observeRequest(completion: @escaping(URLRequest)-> Void) {
        URLProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        URLProtocolStub.emit?(request)
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override open func stopLoading() {}
}
