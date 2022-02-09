//
//  ApiURLFactory.swift
//  Main
//
//  Created by Gabriel Santos on 31/01/22.
//

import Foundation

public func makeURL(path: String) -> URL {
    return URL(string: "\(Environment.variable(key: .apiBaseURL))/\(path)")!
}
