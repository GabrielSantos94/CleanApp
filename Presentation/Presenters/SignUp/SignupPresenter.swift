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
    private let loadingView: LoadingView
    private let validation: Validation
    
    public init(alertView: AlertView, addAccount: AddAccount, loadingView: LoadingView, validation: Validation) {
        self.alertView = alertView
        self.addAccount = addAccount
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func signUp(viewModel: SignUpRequest) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            
            guard let addAccountModel = viewModel.toAddAccountModel() else { return }
            
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            addAccount.add(addAccountModel: addAccountModel) { [weak self] result in
                
                switch result {
                case .success:
                    self?.alertView.showMessage(viewModel: .init(title: "Sucesso", message: "Conta criada com sucesso."))
                case .failure(let error):
                    
                    switch error {
                    case .emailInUse:
                        self?.alertView.showMessage(viewModel: .init(title: "Error", message: "Esse email já esta em uso."))
                    default:
                        self?.alertView.showMessage(viewModel: .init(title: "Error", message: "Algo inesperado aconteceu, tente novamente."))
                    }
                }
                self?.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
}
