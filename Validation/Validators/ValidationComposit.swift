//
//  ValidationComposit.swift
//  Validation
//
//  Created by Gabriel Santos on 03/01/22.
//

import Foundation
import Presentation

public final class ValidationComposit: Validation {
    
    private let validations: [Validation]
    
    public init(validations: [Validation]) {
        self.validations = validations
    }
    
    public func validate(data: [String : Any]?) -> String? {
        
        for validation in validations {
            if let errorMessage = validation.validate(data: data) {
                return errorMessage
            }
        }
        return nil
    }
}
