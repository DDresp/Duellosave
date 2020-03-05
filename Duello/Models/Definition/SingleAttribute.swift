//
//  SingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//Database Attribute (single) that stores single Value
protocol SingleAttribute: Attribute {
    
    func getValue() -> StringConvertibleType?
    func setValue(of value: StringConvertibleType) -> ()
    func getCase() -> SingleAttributeCase
    func getEntryType() -> EntryType
}

extension SingleAttribute {
    
    func getEntryType() -> EntryType {
        return getCase().entryType
    }
    
    func getKey() -> String {
        return getCase().key
    }
}
    
protocol SingleAttributeCase {
    var key: String { get }
    var entryType: EntryType { get }
}
