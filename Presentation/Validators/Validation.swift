//
//  Validation.swift
//  Presentation
//
//  Created by Gabriel Santos on 03/01/22.
//

import Foundation

public protocol Validation {
    func validate(data: [String: Any]?) -> String?
}
