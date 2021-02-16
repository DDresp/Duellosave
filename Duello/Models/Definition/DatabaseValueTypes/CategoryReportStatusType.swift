//
//  CategoryReportStatusType.swift
//  Duello
//
//  Created by Darius Dresp on 2/16/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import Foundation

//WARNING
//Cloud functions use those keys, so if you change them, you have to change the cloud functions

enum CategoryReportStatusType: String, DatabaseConvertibleType, CaseIterable {
    
    case noReport
    case inappropriate
    case inactive
    
    func toStringValue() -> String {
        return self.rawValue
    }
    
}
