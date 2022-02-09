//
//  UseCaseFactory.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import Domain
import Data

func makeRemoteAddAccount() -> AddAccount {
    return makeRemoteAddAccount(httpClient: makeAlamofireAdapter())
}

func makeRemoteAddAccount(httpClient: HttpPostClient) -> AddAccount {
    return RemoteAddAccount(url: makeURL(path: "signup"), httpClient: httpClient)
}
