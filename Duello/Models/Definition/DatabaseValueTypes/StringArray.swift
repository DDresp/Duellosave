//
//  StringArray.swift
//  Duello
//
//  Created by Darius Dresp on 4/14/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

extension Array: DatabaseConvertibleType where Element == String {
    func toStringValue() -> String {
        return "\(self)"
    }
}
