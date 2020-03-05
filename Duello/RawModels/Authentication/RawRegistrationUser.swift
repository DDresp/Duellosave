//
//  RawRegistrationUser.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct RawRegistrationUser {
    
    var email: String?
    var password: String?
    var confirmedPassword: String?
    
    mutating func configure(viewModel: RegistrationDisplayer) {
        email = viewModel.email.value
        password = viewModel.password.value
        confirmedPassword = viewModel.confirmedPassword.value
    }
}
