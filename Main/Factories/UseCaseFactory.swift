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
    private static let apiBaseURL = Environment.variable(key: .apiBaseURL)
    
    private static func makeURL(path: String) -> URL {
        return URL(string: "\(apiBaseURL)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        let remoRemoteAddAccount = RemoteAddAccount(url: makeURL(path: "signup"), httpClient: httpClient)
        return MainQueueDispatchDecorator(remoRemoteAddAccount)
    }
}

public final class MainQueueDispatchDecorator<T> {
    
    private let instance: T
    
    public init(_ instance: T) {
        self.instance = instance
    }
    
    func dispatch(completion: @escaping() -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
