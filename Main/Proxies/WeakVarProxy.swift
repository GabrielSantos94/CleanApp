//
//  WeakVarProxy.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation

final class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}
