//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Gabriel Santos on 27/10/21.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(accessToken: "any_token")
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(
        name: "gabriel",
        email: "invalid_email@mail.com",
        password: "bla123",
        passwordConfirmation: "bla123"
    )
}

func makeAuthenticationModel() -> AuthenticationModel {
    return AuthenticationModel(
        email: "invalid_email@mail.com",
        password: "bla123"
    )
}
