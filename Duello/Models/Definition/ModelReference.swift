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
    func getType() -> ModelReferenceType
}

extension ModelReference {
    func getKey() -> String {
        return getType().key
    }
}

protocol ModelReferenceType {
    var key: String { get }
}
