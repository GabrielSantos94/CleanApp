//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 06/12/21.
//

import XCTest
@testable import Presentation

class SignupPresenter {
    
    private let alertView: AlertView
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Campo nome obrigatório"))
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Campo email obrigatório"))
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Campo senha obrigatório"))
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Campo senha de confirmação obrigatório"))
        }
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}

struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

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
