//
//  LoginPresenterTests.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 02/02/22.
//

import XCTest
import Domain

@testable import Presentation

class LoginPresenterTests: XCTestCase {
    
    func test_validation_should_call_email_validator_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel: viewModel)
        
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJson()!))
    }
    
    func xtestLoginShouldShowErrorIfValidationFails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)
        let exp = expectation(description: "waiting")
        
        alertViewSpy.observer { alertViewModel in
            XCTAssertEqual(alertViewModel, AlertViewModel(title: "Falha na validação", message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func testLoginShouldCallAuthentication_with_correct_values() {
        let authentication = AuthenticationSpy()
        let sut = makeSut(authentication: authentication)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel: viewModel)
        
        XCTAssertEqual(authentication.authenticationModel, makeAuthenticationModel())
    }
    
    func test_login_should_show_generic_error_message_if_autentication_fails() {
        
        let alertViewSpy = AlertViewSpy()
        let authentication = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authentication)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Algo inesperado aconteceu, tente novamente."))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authentication.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_expired_session_error_if_autentication_completes_with_expired_session() {
        
        let alertViewSpy = AlertViewSpy()
        let authentication = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authentication)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Email e ou senha invalidos"))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authentication.completeWithError(.sessionExpired)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_succes_if_authentication_succeeds() {
        
        let alertViewSpy = AlertViewSpy()
        let authentication = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authentication)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Sucesso", message: "Login feito com sucesso."))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        authentication.completionWithAuthentication(makeAuthenticationModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_loading_before_and_after_authentication() {
        
        let loadingViewSpy = LoadingViewSpy()
        let authentication = AuthenticationSpy()
        let sut = makeSut(loadingView: loadingViewSpy, authentication: authentication)
        
        let exp = expectation(description: "waiting")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
        
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        
        authentication.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

extension LoginPresenterTests {
    
    func makeSut(
        alertView: AlertViewSpy = AlertViewSpy(),
        loadingView: LoadingViewSpy = LoadingViewSpy(),
        authentication: AuthenticationSpy = AuthenticationSpy(),
        validation: ValidationSpy = ValidationSpy()) -> LoginPresenter {
            
            return LoginPresenter(
                alertView: alertView,
                loadingView: loadingView,
                authentication: authentication,
                validation: validation
            )
        }
}
