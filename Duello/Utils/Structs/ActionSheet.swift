//
//  ActionSheet.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

struct ActionWarning {
    let title: String
    let message: String
}

struct AlertAction {
    let title: String
    let actionWarning: ActionWarning?
    let handler: (() -> Void)?
    
    init(title: String, actionWarning: ActionWarning? = nil, handler: (() -> Void)?) {
        self.title = title
        self.actionWarning = actionWarning
        self.handler = handler
    }
}

struct ActionSheet {
    var actionHeader: String? = nil
    var actionMessage: String? = nil
    var actions: [AlertAction]
    
}

