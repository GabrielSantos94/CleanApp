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

    // I scaped this test because the api is out
    
    func scaping_test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.com/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        
        let addAccountModel = AddAccountModel(
            name: "Gabriel",
            email: "santos.gabrieljesus@outlook.com",
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
    }
}
