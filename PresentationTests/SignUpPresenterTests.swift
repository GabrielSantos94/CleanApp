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
        
        let (sut, alertViewSpy, _) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(email: "bla", password: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo nome obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        
        let (sut, alertViewSpy, _) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", password: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo email obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provided() {
        
        let (sut, alertViewSpy, _) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", email: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provided() {
        
        let (sut, alertViewSpy, _) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", email: "bla", password: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha de confirmação obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_match() {
        
        let (sut, alertViewSpy, _) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", email: "bla", password: "blabla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Erro ao confirmar senha"))
    }
    
    func test_signup_should_call_email_validator_with_correct_email() {
        
        let (sut, _,emailValidatorSpy) = makeSut()
        
        let signUpViewModel = SignUpViewModel(
            name: "gabriel",
            email: "invalid_email@mail.com",
            password: "bla123",
            passwordConfirmation: "bla123"
        )
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        
        let (sut, alertViewSpy, emailValidatorSpy) = makeSut()
        
        let signUpViewModel = SignUpViewModel(
            name: "gabriel",
            email: "invalid_email@mail.com",
            password: "bla123",
            passwordConfirmation: "bla123"
        )
        emailValidatorSpy.isValid = false
        
        sut.signUp(viewModel: signUpViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Email inválido"))
    }
}

extension SignUpPresenterTests {
    
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, emailValidatorSpy: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        return (sut, alertViewSpy, emailValidatorSpy)
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
    }
}
