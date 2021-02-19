//
//  StringConvertibleType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

//Used to work with Database Attribute Values
//every value that should be stored in the database, should be able to be casted into a String
//the value can be then stored as a String or at its Original Type in the database
protocol DatabaseConvertibleType {
    func toStringValue() -> String
}

protocol DatabaseEnum: CaseIterable, RawRepresentable, DatabaseConvertibleType where RawValue == String {}
