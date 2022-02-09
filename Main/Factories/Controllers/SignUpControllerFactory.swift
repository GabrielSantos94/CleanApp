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
    return [
        RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome"),
        RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
        EmailValidation(
            fieldName: "email",
            fieldLabel: "Email",
            emailValidator: makeEmailValidatorAdapter()
        ),
        RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha"),
        RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar Senha"),
        CompareFieldsValidation(
            fieldName: "password",
            fieldNameToCompare: "passwordConfirmation",
            fieldLabel: "Confirmar Senha"
        )
    ]
}
