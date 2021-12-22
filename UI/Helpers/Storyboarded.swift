//
//  Storyboarded.swift
//  UI
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import UIKit

public protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func instantiate() -> Self {
        let viewControllerName = String(describing: self)
        let sb = UIStoryboard(name: viewControllerName, bundle: Bundle(for: Self.self))
        return sb.instantiateViewController(withIdentifier: viewControllerName) as! Self
    }
}
