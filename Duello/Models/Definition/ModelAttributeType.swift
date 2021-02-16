//
//  SingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol ModelAttributeType {
    
    func getValue() -> DatabaseConvertibleType?
    func setValue(of value: DatabaseConvertibleType) -> ()
    func getCase() -> ModelAttributeCase
    func getEntryType() -> EntryType
}

extension ModelAttributeType {
    
    func getEntryType() -> EntryType {
        return getCase().entryType
    }
    
    func getKey() -> String {
        return getCase().key
    }
}
    
protocol ModelAttributeCase {
    var key: String { get }
    var entryType: EntryType { get }
}
