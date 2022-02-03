//
//  LoginPresenter.swift
//  Presentation
//
//  Created by Gabriel Santos on 06/12/21.
//

import Foundation
import Domain

public final class LoginPresenter {
    
    private let validation: Validation
    private let authentication: Authentication
    private let alertView: AlertView
    private let loadingView: LoadingView
    
    public init(alertView: AlertView,
                loadingView: LoadingView,
                authentication: Authentication,
                validation: Validation) {
        
        self.alertView = alertView
        self.loadingView = loadingView
        self.validation = validation
        self.authentication = authentication
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                
                switch result {
                case .success:
                    self?.alertView.showMessage(viewModel: .init(title: "Sucesso", message: "Login feito com sucesso."))
                case .failure(let error):
                    switch error {
                    case .sessionExpired:
                        self?.alertView.showMessage(viewModel: .init(title: "Error", message: "Email e ou senha invalidos"))
                    default:
                        self?.alertView.showMessage(viewModel: .init(title: "Error", message: "Algo inesperado aconteceu, tente novamente."))
                    }
                }
                self?.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
}
