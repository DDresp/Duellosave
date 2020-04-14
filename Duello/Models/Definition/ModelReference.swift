//
//  MapAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//Database Attribute (map) that stores another Model
protocol ModelReference {
    func getModel() -> Model
    func getCase() -> ModelReferenceCase
}

extension ModelReference {
    func getKey() -> String {
        return getCase().key
    }
}

protocol ModelReferenceCase {
    var key: String { get }
}
