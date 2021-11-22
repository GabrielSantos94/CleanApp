//
//  InfraTests.swift
//  InfraTests
//
//  Created by Gabriel Santos on 09/11/21.
//

import XCTest
import Alamofire
import Data
import Infra

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
    
    func test_post_should_complete_with_data_when_request_completes_with_200() {
        let data = makeValidData()
        expect(expectedResult: .success(data), when: (data: data, response: makeHTTPResponse(), error: nil))
    }
    
    func test_post_should_complete_with_no_data_when_request_completes_with_204() {
        expect(expectedResult: .success(nil), when: (data: nil, response: makeHTTPResponse(statusCode: 204), error: nil))
        expect(expectedResult: .success(nil), when: (data: makeEmptyData(), response: makeHTTPResponse(statusCode: 204), error: nil))
        expect(expectedResult: .success(nil), when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 204), error: nil))
    }
    
    func test_post_should_complete_with_error_when_request_completes_different_from_200() {
        expect(expectedResult: .failure(.badRequest),when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 400), error: nil))
        expect(expectedResult: .failure(.serverError),when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 500), error: nil))
        expect(expectedResult: .failure(.unauthorized),when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 401), error: nil))
        expect(expectedResult: .failure(.forbidden),when: (data: makeValidData(), response: makeHTTPResponse(statusCode: 403), error: nil))
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
    
    func expect(expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?)) {
        
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
