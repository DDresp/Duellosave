//
//  DuelloError.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol DuelloError: Error {
    var errorHeader: String { get }
    var errorMessage: String { get }
}
