//
//  LoadingViewProxy.swift
//  Main
//
//  Created by Gabriel Santos on 23/12/21.
//

import Foundation
import Presentation

extension WeakVarProxy: LoadingView where T: LoadingView {
    func display(viewModel: LoadingViewModel) {
        instance?.display(viewModel: viewModel)
    }
}
