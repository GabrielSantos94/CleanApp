//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Gabriel Santos on 06/12/21.
//

import Foundation
import Domain

public final class SignupPresenter {
    
    private let addAccount: AddAccount
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    private let loadingView: LoadingView
    
    public init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
        self.loadingView = loadingView
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validade(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            
            guard let name = viewModel.name,
                  let email = viewModel.email,
                  let password = viewModel.password,
                  let passwordConfirmation = viewModel.passwordConfirmation
            else { return }
            
            let addAccountModel = AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
            
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            addAccount.add(addAccountModel: addAccountModel) { [weak self] result in
                
                switch result {
                case .success(let account):
                    self?.alertView.showMessage(viewModel: .init(title: "Sucesso", message: "Conta criada com sucesso."))
                case .failure:
                    self?.alertView.showMessage(viewModel: .init(title: "Error", message: "Algo inesperado aconteceu, tente novamente."))
                }
                self?.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
    
    private func validade(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "O campo nome é obrigatório."
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "O campo email é obrigatório."
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "O campo senha é obrigatório."
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "O campo senha de confirmação é obrigatório."
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "O campo confirmar senha é inválido."
        } else if !emailValidator.isValid(email: viewModel.email!) {
            return "O campo email é inválido."
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
