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
    case noImageUrl
    case noVideoUrl
    case noThumbnail
    case noId
    case noMediaRatio
    case deactive
    
    var errorHeader: String {
        
        switch self {
            
        case .badLink: return "Bad Link"
        case .networkError: return "Network Error"
        case .unknown: return "Error"
        case .noImageUrl: return "Image not found"
        case .noVideoUrl: return "Video not found"
        case .noThumbnail: return "No Thumbnail"
        case .noId: return "Id not found"
        case .noMediaRatio: return "MediaRatio not found"
        case .deactive: return "Link Failed"
        }
        
    }
    
    var errorMessage: String {
        
        switch self {
            
        case .badLink: return "Please check if the provided link is correct"
        case .networkError: return "Please check your internet connection"
        case .unknown(let msg): return msg
        case .noImageUrl: return "Your Instagram post contains no image"
        case .noVideoUrl: return "Your instagram post contains no video"
        case .noThumbnail: return "Your Instagram post contains no thumbnail"
        case .noId: return "Your instagram post seems to contain no id"
        case .noMediaRatio: return "Your instagram post seems to have no associated size"
        case .deactive: return "The link you provided didn't work. (If the instagram account associated with the link is private, the link won't work)"
            
        }
    }
    
}
