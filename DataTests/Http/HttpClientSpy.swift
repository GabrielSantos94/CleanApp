//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Gabriel Santos on 27/10/21.
//

import Foundation
import Data

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
