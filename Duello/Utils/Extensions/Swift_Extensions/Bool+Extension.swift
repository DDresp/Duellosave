//
//  Bool+Extension.swift
//  Duello
//
//  Created by Darius Dresp on 3/14/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

extension Bool: DatabaseConvertibleType {
    
    func toStringValue() -> String {
        return (self == true) ? "1" : "0"
    }
    
}

