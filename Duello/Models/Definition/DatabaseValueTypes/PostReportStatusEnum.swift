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

enum PostReportStatusEnum: String, DatabaseEnum {
    
    case noReport
    case deletedButReviewed
    case inappropriate
    case fakeUser
    case wrongCategory
    
}
