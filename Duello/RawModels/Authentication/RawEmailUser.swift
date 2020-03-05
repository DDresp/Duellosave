//
//  RawEmailUser.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct RawEmailUser {
    
    var email: String?
    var password: String?
    
    mutating func configure(viewModel: EmailLoginDisplayer) {
        email = viewModel.email.value
        password = viewModel.password.value
    }
}
