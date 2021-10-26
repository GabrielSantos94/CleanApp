//
//  AccountModel.swift
//  Domain
//
//  Created by Gabriel Santos on 19/10/21.
//

import Foundation

public struct AccountModel: Encodable {
    public var id: String
    public var name: String
    public var email: String
    public var password: String
}
