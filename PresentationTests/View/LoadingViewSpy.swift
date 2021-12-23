//
//  LoadingViewSpy.swift
//  PresentationTests
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import Presentation

class LoadingViewSpy: LoadingView {
    var emit: ((LoadingViewModel) -> Void)?
    
    func observer(completion: @escaping(LoadingViewModel) -> Void) {
        self.emit = completion
    }
    
    func display(viewModel: LoadingViewModel) {
        self.emit?(viewModel)
    }
    
}
