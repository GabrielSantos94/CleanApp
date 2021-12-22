//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Gabriel Santos on 06/12/21.
//

import Foundation

public final class SignupPresenter {
    
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    
    public init(alertView: AlertView, emailValidator: EmailValidator) {
        self.alertView = alertView
        self.emailValidator = emailValidator
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validade(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: message))
        }
    }
    
    private func validade(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "Campo nome obrigatório"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "Campo email obrigatório"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "Campo senha obrigatório"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "Campo senha de confirmação obrigatório"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "Erro ao confirmar senha"
        } else if !emailValidator.isValid(email: viewModel.email!) {
            return "Email inválido"
        }
        return nil
    }
}

public struct SignUpViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
    
    public init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
