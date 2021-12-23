//
//  UseCaseFactory.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import Domain
import Data
import Infra

final class UseCaseFactory {
    
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseURL = Enviroment.variable(key: .apiBaseURL)
    
    private static func makeURL(path: String) -> URL {
        return URL(string: "\(apiBaseURL)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        return RemoteAddAccount(url: makeURL(path: "signup"), httpClient: httpClient)
    }
}
