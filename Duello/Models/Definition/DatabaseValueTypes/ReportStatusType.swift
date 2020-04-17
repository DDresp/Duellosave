//
//  ReportType.swift
//  Duello
//
//  Created by Darius Dresp on 4/16/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import Foundation

//WARNING
//Cloud functions use those keys, so if you change them, you have to change the cloud functions

enum ReportStatusType: String, DatabaseConvertibleType {
    
    case notReported
    case reviewRequested
    case inappropriate
    case fakeUser
    case wrongCategory
    
    func toStringValue() -> String {
        return self.rawValue
    }
    
}
