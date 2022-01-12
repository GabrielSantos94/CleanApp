//
//  ValidationSpy.swift
//  Presentation
//
//  Created by Gabriel Santos on 03/01/22.
//

import Foundation

class ValidationSpy: Validation {
    var data: [String : Any]?
    var errorMessage: String?
    
    func validate(data: [String : Any]?) -> String? {
        self.data = data
        return nil
    }
    
    func simulateError() {
        self.errorMessage = "Erro"
    }
}
