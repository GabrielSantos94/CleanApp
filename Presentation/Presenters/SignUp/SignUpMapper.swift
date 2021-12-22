//
//  SignUpMapper.swift
//  Presentation
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import Domain

public final class SignUptMapper {
    
    static func toAddAccountModel(viewModel: SignUpViewModel) -> AddAccountModel? {
        
        guard let name = viewModel.name,
              let email = viewModel.email,
              let password = viewModel.password,
              let passwordConfirmation = viewModel.passwordConfirmation
        else { return nil }
        
        return AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
}
