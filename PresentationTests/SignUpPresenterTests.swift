//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 06/12/21.
//

import XCTest
import Domain

@testable import Presentation

class SignUpPresenterTests: XCTestCase {
    
    func test_signup_should_show_error_message_if_name_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "nome"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "email"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "senha"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel,makeRequiredAlertViewModel(fieldName: "senha de confirmação"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_match() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "bla"))
        
        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "confirmar senha"))
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "email"))
    }
    
    func test_signup_should_call_email_validator_with_correct_email() {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signup_should_call_email_validator_with_correct_values() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
}

extension SignUpPresenterTests {
    
    func makeSignUpViewModel(
        name: String? = "gabriel",
        email: String? = "invalid_email@mail.com",
        password: String? = "bla123",
        passwordConfirmation: String? = "bla123") -> SignUpViewModel {
            
            return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
        }
    
    func makeSut(
        alertView: AlertViewSpy = AlertViewSpy(),
        emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
        addAccount: AddAccountSpy = AddAccountSpy()) -> SignupPresenter {
        
            let sut = SignupPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount)
        
        return sut
    }
    
    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório.")
    }
    
    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido.")
    }
    
    class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
        
        func simulateInvalidEmail() {
            isValid = false
        }
    }
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
        }
    }
}
