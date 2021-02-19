//
//  MediaType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

enum FineMediaEnum: String, DatabaseEnum {
    
    case localVideo
    case localImages
    case localSingleImage
    case instagramVideo
    case instagramSingleImage
    case instagramImages
    
    func toStringValue() -> String {
        return self.rawValue
    }
    
}
