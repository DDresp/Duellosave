//
//  MapAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//Database Attribute (map) that stores another Model
protocol MapAttribute: Attribute {
    func getModel() -> Model
    func getCase() -> MapAttributeCase
}

extension MapAttribute {
    func getKey() -> String {
        return getCase().key
    }
}

protocol MapAttributeCase {
    var key: String { get }
}
