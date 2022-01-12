//
//  TestFactories.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import Presentation

func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
    return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório.")
}

func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
    return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido.")
}

func makeSignUpViewModel(name: String? = "gabriel", email: String? = "invalid_email@mail.com", password: String? = "bla123", passwordConfirmation: String? = "bla123") -> SignUpViewModel {
    return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}
