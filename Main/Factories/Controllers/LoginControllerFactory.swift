//
//  LoginControllerFactory.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import UI
import Presentation
import Validation
import Data
import Domain

public func makeLoginController() -> LoginViewController {
    return makeLoginControllerWith(authentication: makeRemoteAuthentication())
}

public func makeLoginControllerWith(authentication: Authentication) -> LoginViewController {
    let controller = LoginViewController.instantiate()
    let validationComposite = ValidationComposit(validations: makeLoginValidations())
    
    let presenter = LoginPresenter(
        alertView: WeakVarProxy(controller),
        loadingView: WeakVarProxy(controller),
        authentication: authentication,
        validation: validationComposite
    )
    
    controller.login = presenter.login
    
    return controller
}

public func makeLoginValidations() -> [Validation] {
    
    return ValidationBuilder.field("email").label("Email").required().email().build() +
    ValidationBuilder.field("password").label("Senha").required().build()
}
