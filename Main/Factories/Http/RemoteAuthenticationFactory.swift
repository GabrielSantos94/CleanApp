//
//  RemoteAuthenticationFactory.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import Domain
import Data

func makeRemoteAuthentication(httpClient: HttpPostClient) -> Authentication {
    let remoteAuthentication = RemoteAuthentication(url: makeURL(path: "login"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteAuthentication)
}
