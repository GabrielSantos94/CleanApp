//
//  RemoteAuthentication.swift
//  Data
//
//  Created by Gabriel Santos on 02/02/22.
//

import Foundation
import Domain

public final class RemoteAuthentication: Authentication {
    
    public let url: URL
    public let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        httpClient.post(to: url, with: authenticationModel.toData()) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let data):
                if let model: AuthenticationModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure(let error):
                switch error {
                case .unauthorized:
                    completion(.failure(.sessionExpired))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
