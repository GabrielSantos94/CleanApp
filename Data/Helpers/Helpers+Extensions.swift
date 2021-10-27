//
//  Helpers+Extensions.swift
//  Data
//
//  Created by Gabriel Santos on 26/10/21.
//

import Foundation

public extension Data {
    
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
