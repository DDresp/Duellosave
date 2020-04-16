//
//  RoughMediaType.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

enum RoughMediaType: String, DatabaseConvertibleType {
    
    case video
    case image
    case videoAndImage
    
    func toStringValue() -> String {
        return self.rawValue
    }
    
}

