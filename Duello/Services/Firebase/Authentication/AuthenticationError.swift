//
//  AuthenticationError.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation
import Firebase

enum AuthenticationError: DuelloError {
    
    case verificationNeeded
    case invalidEmail
    case invalidPassword
    case invalidConfirmedPassword
    case unknown(description: String)
    case userNotFound
    case wrongPassword
    case tooManyRequests
    case networkError
    case invalidVerificationCode
    case invalidPhoneNumber
    case canceled
    case authenticationFailed
    case userNotLoggedIn
    
    internal init(error: Error) {
        
        guard let errorCode = AuthErrorCode(rawValue: error._code) else {
            self = .unknown(description: "an unknown error occurred!")
            return }
        
        switch errorCode {
        case .userNotFound: self = .userNotFound
        case .wrongPassword: self = .wrongPassword
        case .tooManyRequests: self = .tooManyRequests
        case .networkError: self = .networkError
        case .invalidVerificationCode: self = .invalidVerificationCode
        case .invalidPhoneNumber: self = .invalidPhoneNumber
        default: self = .unknown(description: error.localizedDescription)
        }
        
    }
    
    var errorHeader: String {
        
        switch self {
        case .invalidPassword, .invalidEmail, .invalidConfirmedPassword: return "Invalid Input"
        case .unknown: return "Error"
        case .userNotFound: return "User Not Found"
        case .wrongPassword: return "Wrong Password"
        case .tooManyRequests: return "Error"
        case .networkError: return "Network Error"
        case .verificationNeeded: return "Not Verified"
        case .invalidVerificationCode: return "Wrong Verification Code"
        case .invalidPhoneNumber: return "Invalid Phone Number"
        case .canceled: return "Canceled"
        case .authenticationFailed: return "Authentication Failed"
        case .userNotLoggedIn: return "Not Logged In"
        }
        
    }
    
    var errorMessage: String {
        
        switch self {
        case .invalidPassword: return "Please provide a valid password"
        case .invalidEmail: return "Please provide a valid email address"
        case .invalidConfirmedPassword: return "Confirmed password doesn't match password"
        case .unknown(let msg): return msg
        case .userNotFound: return "User can't be found. Please check your email again."
        case .wrongPassword: return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .tooManyRequests: return "Too many false attempts. Please try again later."
        case .networkError: return "Network Error. Please check your internet connection."
        case .verificationNeeded: return "Email address isn't verified. Please also look in your junk folder."
        case .invalidVerificationCode: return "The verification code you entered is not correct. Please try again."
        case .invalidPhoneNumber: return "Please enter a valid phone number."
        case .canceled: return "You canceled the request"
        case .authenticationFailed: return "user couldn't be authenticated, please try later again"
        case .userNotLoggedIn: return "You have to login to perform this action"
        }
        
    }
}
