//
//  Timestamp+Extension.swift
//  Duello
//
//  Created by Darius Dresp on 2/16/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import Firebase

extension Timestamp: DatabaseConvertibleType {
    
    func toStringValue() -> String {
        return self.dateValue().description
    }
    
    
}
