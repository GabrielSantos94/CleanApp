//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 06/12/21.
//

import XCTest

@testable import Presentation

class SignUpPresenterTests: XCTestCase {
    
    func test_signup_should_show_error_message_if_name_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo nome obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo email obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha de confirmação obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_match() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "bla"))
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Erro ao confirmar senha"))
    }
    
    func test_signup_should_call_email_validator_with_correct_email() {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Email inválido"))
    }
}

extension SignUpPresenterTests {
    
    func makeSignUpViewModel(
        name: String? = "gabriel",
        email: String? = "invalid_email@mail.com",
        password: String? = "bla123",
        passwordConfirmation: String? = "bla123"
    ) -> SignUpViewModel {
        
        return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeSut(
        alertView: AlertViewSpy = AlertViewSpy(),
        emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignupPresenter {
            
            let sut = SignupPresenter(alertView: alertView, emailValidator: emailValidator)
            
            return sut
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
}
