//
//  SignUpComposer.swift
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

public func makeSignupController() -> SignUpViewController {
    return makeSignupControllerWith(addAccount: makeRemoteAddAccount())
}

public func makeSignupControllerWith(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposit(validations: makeSignupValidations())
    
    let presenter = SignupPresenter(
        alertView: WeakVarProxy(controller),
        addAccount: addAccount,
        loadingView: WeakVarProxy(controller),
        validation: validationComposite
    )
    
    controller.signUp = presenter.signUp
    
    return controller
}

public func makeSignupValidations() -> [Validation] {
    
    return ValidationBuilder.field("name").label("Nome").required().build() +
    ValidationBuilder.field("email").label("Email").required().email().build() +
    ValidationBuilder.field("password").label("Senha").required().build() +
    ValidationBuilder.field("passwordConfirmation").label("Confirmar Senha").asSameAs("password").build()
}
