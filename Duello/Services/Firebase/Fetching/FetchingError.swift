//
//  FetchingError.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation
import Firebase

enum DownloadError: DuelloError {
    
    case userNotLoggedIn
    case unknown(description: String)
    case networkError
    case noData
    
    internal init(error: Error) {
        
        guard let errorCode = AuthErrorCode(rawValue: error._code) else {
            self = .unknown(description: "an unknown error occurred!")
            return }
        
        switch errorCode {
        default: self = .unknown(description: error.localizedDescription)
        }
        
    }
    
    var errorHeader: String {
        
        switch self {
        case .userNotLoggedIn: return "Not Logged In"
        case .networkError: return "Network Error"
        case .unknown: return "Error"
        case .noData: return "No Data"
        }
        
    }
    
    var errorMessage: String {
        
        switch self {
        case .userNotLoggedIn: return "You have to login to perform this action"
        case .networkError: return "Please check your internet connection"
        case .unknown(let msg): return msg
        case .noData: return "no data received from Firebase"
        }
    }
    
}
