//
//  DomainError.swift
//  Domain
//
//  Created by Gabriel Santos on 26/10/21.
//

import Foundation

public enum DomainError: Error {
    case unexpected
    case emailInUse
    case sessionExpired
}
