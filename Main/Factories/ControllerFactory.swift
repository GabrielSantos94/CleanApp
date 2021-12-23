//
//  SignUpViewControllerFactory.swift
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

class ControllerFactory {
    static func makeSignUp(addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        
        let presenter = SignupPresenter(
            alertView: WeakVarProxy(controller),
            emailValidator: emailValidatorAdapter,
            addAccount: addAccount,
            loadingView: WeakVarProxy(controller)
        )
        
        controller.signUp = presenter.signUp
        
        return controller
    }
}