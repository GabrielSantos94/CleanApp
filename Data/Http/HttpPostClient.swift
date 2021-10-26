//
//  HttpPostClient.swift
//  Data
//
//  Created by Gabriel Santos on 25/10/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void)
}
