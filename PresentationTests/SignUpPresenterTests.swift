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
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "nome"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "email"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "senha"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provided() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "senha de confirmação"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_match() {
        
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "confirmar senha"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "bla"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "email"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
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
    
    func test_signup_should_show_error_message_if_addAccount_fails() {
        
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente."))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_loading_before_call_addAccount() {
        
        let loadingViewSpy = LoadingViewSpy()
        let sut = makeSut(loadingView: loadingViewSpy)
        
        sut.signUp(viewModel: makeSignUpViewModel())
        
        XCTAssertEqual(loadingViewSpy.viewModel, LoadingViewModel(isLoading: true))
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
        addAccount: AddAccountSpy = AddAccountSpy(),
        loadingView: LoadingViewSpy = LoadingViewSpy()) -> SignupPresenter {
        
            let sut = SignupPresenter(
                alertView: alertView,
                emailValidator: emailValidator,
                addAccount: addAccount,
                loadingView: loadingView
            )
        
        return sut
    }
    
    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório.")
    }
    
    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido.")
    }
    
    func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        return AlertViewModel(title: "Error", message: message)
    }
    
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observer(completion: @escaping(AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
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
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) {
            completion?(.failure(error))
        }
    }
    
    class LoadingViewSpy: LoadingView {
        var viewModel: LoadingViewModel?
        
        func display(viewModel: LoadingViewModel) {
            self.viewModel = viewModel
        }
    }
}