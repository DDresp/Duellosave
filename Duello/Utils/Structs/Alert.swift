//
//  Alert.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct Alert {
    var alertHeader: String?
    var alertMessage: String?
    
    init(alertMessage: String?, alertHeader: String?) {
        self.alertMessage = alertMessage
        self.alertHeader = alertHeader
    }
    
}
