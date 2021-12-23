//
//  AlertViewSpy.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import Presentation

class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?
    
    func observer(completion: @escaping(AlertViewModel) -> Void) {
        self.emit = completion
    }
    
    func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}
