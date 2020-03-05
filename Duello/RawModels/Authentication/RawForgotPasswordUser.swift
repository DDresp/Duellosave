//
//  RawForgotPasswordUser.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct RawForgotPasswordUser {
    
    var email: String?
    
    mutating func configure(viewModel: ForgotPasswordDisplayer) {
        email = viewModel.email.value
    }
}
