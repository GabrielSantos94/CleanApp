//
//  EmailValidator.swift
//  Presentation
//
//  Created by Gabriel Santos on 06/12/21.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
