//
//  UIViewController+Extensions.swift
//  UI
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyBoard() {
        view.endEditing(true)
    }
}
