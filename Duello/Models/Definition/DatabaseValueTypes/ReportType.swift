//
//  ReportType.swift
//  Duello
//
//  Created by Darius Dresp on 4/16/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import Foundation

enum ReportType: String, DatabaseConvertibleType {
    
    case notReported
    case inappropriate
    case fakeUser
    case wrongCategory
    
    func toStringValue() -> String {
        return self.rawValue
    }
    
}
