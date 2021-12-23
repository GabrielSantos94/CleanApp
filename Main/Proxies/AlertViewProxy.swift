//
//  AlertViewProxy.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import Presentation

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}
