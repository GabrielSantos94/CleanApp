//
//  TestFactories.swift
//  DataTests
//
//  Created by Gabriel Santos on 27/10/21.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Gabriel\"}".utf8)
}

func makeEmptyData() -> Data {
    return Data()
}

func makeURL() -> URL {
    return URL(string: "www.google.com.br")!
}

func makeError() -> Error {
    return NSError(domain: "Error", code: 999)
}

func makeHTTPResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
