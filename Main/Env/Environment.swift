//
//  Environment.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation

public final class Environment {
    
    public enum Enviroments: String {
        case apiBaseURL = "API_BASE_URL"
    }
    
    public static func variable(key: Enviroments) -> String {
        return Bundle.main.infoDictionary?[key.rawValue] as! String
    }
}
