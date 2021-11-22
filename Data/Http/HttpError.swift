//
//  HttpError.swift
//  Data
//
//  Created by Gabriel Santos on 26/10/21.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
