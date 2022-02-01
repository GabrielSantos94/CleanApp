//
//  AccountModel.swift
//  Domain
//
//  Created by Gabriel Santos on 19/10/21.
//

import Foundation

public struct AccountModel: Model {
    public var accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
