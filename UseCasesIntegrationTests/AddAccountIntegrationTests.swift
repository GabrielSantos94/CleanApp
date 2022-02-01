//
//  AddAccountIntegrationTests.swift
//  AddAccountIntegrationTests
//
//  Created by Gabriel Santos on 23/11/21.
//

import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {
    
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.com/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        
        let addAccountModel = AddAccountModel(
            name: "Gabriel",
            email: "\(UUID().uuidString)@gmail.com",
            password: "secret",
            passwordConfirmation: "secret"
        )
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            case .failure:
                XCTFail("Expect to return success, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
        let exp2 = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error) where error == .emailInUse:
                XCTAssertNotNil(error)
            default:
                XCTFail("Expect to return success, got \(result) instead")
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5)
    }
}
