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

public func makeLoginController(authentication: Authentication) -> LoginViewController {
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
    return [
        RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
        EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
        RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha")
    ]
}
