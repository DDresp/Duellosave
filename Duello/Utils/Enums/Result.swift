//
//  Result.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(NSError)
    
}
