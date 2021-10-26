//
//  Model.swift
//  Domain
//
//  Created by Gabriel Santos on 25/10/21.
//

import Foundation

public protocol Model: Encodable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
