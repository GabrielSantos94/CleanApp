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

class SignUpViewControllerFactory {
    static func makeController() -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        let addAccount = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        
        let presenter = SignupPresenter(
            alertView: controller,
            emailValidator: emailValidatorAdapter,
            addAccount: addAccount,
            loadingView: controller
        )
        
        controller.signUp = presenter.signUp
        
        return controller
    }
}
