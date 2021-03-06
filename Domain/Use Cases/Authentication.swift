//
//  Authentication.swift
//  Domain
//
//  Created by Gabriel Santos on 19/10/21.
//

import Foundation

public protocol Authentication {
    typealias Result = Swift.Result<AuthenticationModel, DomainError>
    
    func auth(authenticationModel: AuthenticationModel, completion: @escaping (Result) -> Void)
}

public struct AuthenticationModel: Model {
    public var email: String
    public var password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
