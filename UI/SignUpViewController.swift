//
//  SignUpViewController.swift
//  UI
//
//  Created by Gabriel Santos on 22/12/21.
//

import Foundation
import UIKit
import Presentation

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SignUpViewController: LoadingView {
    
    func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
