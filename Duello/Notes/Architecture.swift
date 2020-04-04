//
//  Architecture.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

// Memory = Local Cache System to make the app more efficient and faster

// Services = Network Services and Network Logic connecting the app to external Databases

// Models = Usually Save the data from and to the external database, however,  Rawmodels are used to save the data inside the App itself

// Coordinators = Control of the general workflow of the app, i.e. control of when to show which CONTROLLER

// Controllers = For each workflow step in the app = one specific CONTROLLER, however the CONTROLLER can inherit

// ViewModels = Control the displayed data for CONTROLLERS and PRESENTATORS

// Presentators = Presentators are a way to display and control the UI, CONTROLLERS can inherit from them
// Displayers = Protocols to Control the displayed data for PRESENTATORS, ViewModels can conform to them

