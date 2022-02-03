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
    
    public init(alertView: AlertView, authentication: Authentication, validation: Validation) {
        self.alertView = alertView
        self.validation = validation
        self.authentication = authentication
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { _ in }
        }
    }
}
