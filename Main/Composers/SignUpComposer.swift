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
import Infra
import Domain

public final class SignUpComposer {
    static func composeController(with addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let validationComposite = ValidationComposit(validations: makeValidations())
        
        let presenter = SignupPresenter(
            alertView: WeakVarProxy(controller),
            addAccount: addAccount,
            loadingView: WeakVarProxy(controller),
            validation: validationComposite
        )
        
        controller.signUp = presenter.signUp
        
        return controller
    }
    
    public static func makeValidations() -> [Validation] {
        return [
            RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome"),
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
            EmailValidation(
                fieldName: "email",
                fieldLabel: "Email",
                emailValidator: EmailValidatorAdapter()
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
}
