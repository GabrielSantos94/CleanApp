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
        
        let (sut, alertViewSpy) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(email: "bla", password: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo nome obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        
        let (sut, alertViewSpy) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", password: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo email obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_is_not_provided() {
        
        let (sut, alertViewSpy) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", email: "bla", passwordConfirmation: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha obrigatório"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_is_not_provided() {
        
        let (sut, alertViewSpy) = makeSut()
        
        let viewModelViewModel = SignUpViewModel(name: "bla", email: "bla", password: "bla")
        sut.signUp(viewModel: viewModelViewModel)
        
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha", message: "Campo senha de confirmação obrigatório"))
    }
}

extension SignUpPresenterTests {
    
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignupPresenter(alertView: alertViewSpy)
        
        return (sut, alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
