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
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Algo inesperado aconteceu, tente novamente."))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_show_loading_before_and_after_call_addAccount() {
        
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        
        let exp = expectation(description: "waiting")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
        
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
    
    func test_signup_should_show_success_message_if_addAccount_succeeds() {
        
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso."))
            exp.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completionWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signup_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeSignUpViewModel()
        
        sut.signUp(viewModel: viewModel)
        
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJson()!))
    }
    
    func test_signup_should_show_error_message_if_validation_fails() {
        let validationSpy = ValidationSpy()
        let alertViewSpy = AlertViewSpy()
        
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Falha na validação", message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {
    
    func makeSut(
        alertView: AlertViewSpy = AlertViewSpy(),
        addAccount: AddAccountSpy = AddAccountSpy(),
        loadingView: LoadingViewSpy = LoadingViewSpy(),
        validation: ValidationSpy = ValidationSpy()) -> SignupPresenter {
        
            let sut = SignupPresenter(
                alertView: alertView,
                addAccount: addAccount,
                loadingView: loadingView,
                validation: validation
            )
        
        return sut
    }
}
