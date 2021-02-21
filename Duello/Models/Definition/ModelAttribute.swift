//
//  SingleAttribute.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol ModelAttribute {
    
    func getValue() -> DatabaseConvertibleType?
    func setValue(of value: DatabaseConvertibleType?) -> ()
    func getType() -> ModelAttributeType
    func getEntryType() -> EntryType
}

extension ModelAttribute {
    
    func getEntryType() -> EntryType {
        return getType().entryType
    }
    
    func getKey() -> String {
        return getType().key
    }
}
    
protocol ModelAttributeType {
    var key: String { get }
    var entryType: EntryType { get }
}
