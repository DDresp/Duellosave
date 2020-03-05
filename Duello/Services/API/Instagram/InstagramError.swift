//
//  InstagramError.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

enum InstagramError: DuelloError {
    
    case badLink
    case unknown(description: String)
    case networkError
    case noVideoUrl
    case noImageUrl
    case noId
    case failedThumbnail
    case failedRequest
    
    var errorHeader: String {
        
        switch self {
            
        case .badLink: return "Bad Link"
        case .networkError: return "Network Error"
        case .unknown: return "Error"
        case .noVideoUrl: return "Video not found"
        case .noImageUrl: return "Image not found"
        case .noId: return "Id not found"
        case .failedRequest: return "Link Failed"
        case .failedThumbnail: return "No Thumbnail"
        }
        
    }
    
    var errorMessage: String {
        
        switch self {
        case .badLink: return "Please check if the provided link is correct"
        case .networkError: return "Please check your internet connection"
        case .unknown(let msg): return msg
        case .noVideoUrl: return "Your instagram post contains no video"
        case .noImageUrl: return "Your Instagram post contains no image"
        case .noId: return "Your instagram post seems to contain no id"
        case .failedRequest: return "The link you provided didn't work. (If the instagram account associated with the link is private, the link won't work)"
        case .failedThumbnail: return "The Thumbnail creation failed, please try again"
            
        }
    }
    
}
