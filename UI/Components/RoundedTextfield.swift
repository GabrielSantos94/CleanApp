//
//  RoundedTextfield.swift
//  UI
//
//  Created by Gabriel Santos on 01/02/22.
//

import Foundation
import UIKit

public final class RoundedTextfield: UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.borderColor = Color.primaryLight.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        overrideUserInterfaceStyle = .light
    }
}
