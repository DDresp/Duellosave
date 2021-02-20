//
//  StringConvertibleType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase

protocol DatabaseConvertibleType {}

protocol DatabaseEnum: CaseIterable, RawRepresentable, DatabaseConvertibleType where RawValue == String {}

extension Bool: DatabaseConvertibleType {}
extension Int: DatabaseConvertibleType {}
extension Double: DatabaseConvertibleType {}
extension String: DatabaseConvertibleType {}
extension Timestamp: DatabaseConvertibleType {}
extension Array: DatabaseConvertibleType where Element == String {}


