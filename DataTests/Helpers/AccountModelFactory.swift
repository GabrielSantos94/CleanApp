//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Gabriel Santos on 27/10/21.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "", name: "", email: "", password: "")
}
