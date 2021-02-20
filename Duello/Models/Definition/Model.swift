//
//  Model.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase

struct Properties {
    var attributes: [ModelAttribute]?
    var references: [ModelReference]?
}

protocol Model {
    
    var id: String? { get set }
    
}

//MARK: - Mirror Properties
extension Model {
    
    var properties: (Properties) {
        
        let mirror = Mirror(reflecting: self)
        
        var attributes: [ModelAttribute]? = [ModelAttribute]()
        var references: [ModelReference]? = [ModelReference]()
        
        for (_, value) in mirror.children {
            
            if let attribute = value as? ModelAttribute {
                attributes?.append(attribute)
            } else if let reference = value as? ModelReference {
                references?.append(reference)
            }
            
        }
        
        if let atrs = attributes, atrs.count == 0 { attributes = nil }
        if let refs = references, refs.count == 0 { references = nil }
        
        return Properties(attributes: attributes, references: references)
        
    }
    
}

//MARK: - Encoding
extension Model {
    
    func encode() -> [String: Any] {
        
        var dictionary = [String: Any]()
        
        if let attributes = properties.attributes {
            dictionary = encode(attributes: attributes)
        }
        
        if let references = properties.references {
            var referenceDictionary = [String: Any]()
            for reference in references {
                referenceDictionary[reference.getKey()] = reference.getModel().encode()
            }
            
            dictionary += referenceDictionary
        }
        
        return dictionary
    }
    
    private func encode(attributes: [ModelAttribute]) -> [String: Any] {
        var dictionary = [String: Any]()
        for attribute in attributes {
            
            switch attribute.getEntryType() {
            case .Int, .Double, .String, .Timestamp, .Bool, .StringArray:
                dictionary[attribute.getKey()] = attribute.getValue()
            case .FineMediaType:
                dictionary += encodeValue(of: attribute, to: dictionary, enum: FineMediaEnum.self)
            case .RoughMediaType:
                dictionary += encodeValue(of: attribute, to: dictionary, enum: RoughMediaEnum.self)
            case .PostReportStatusType:
                dictionary += encodeValue(of: attribute, to: dictionary, enum: PostReportStatusEnum.self)
            case .CategoryReportStatusType:
                dictionary += encodeValue(of: attribute, to: dictionary, enum: CategoryReportStatusEnum.self)
            }
        }
        
        return dictionary
        
    }
    
    private func encodeValue<T: DatabaseEnum>(of attribute: ModelAttribute, to dic: [String: Any], enum: T.Type) -> [String: Any] {
        var newDic = dic
        if let value = attribute.getValue() as? T {
            newDic[attribute.getKey()] = value.rawValue
        }
        return newDic
    }
    

}

//MARK: - Decoding
extension Model {
    
    mutating func decode(with dic: [String: Any], id: String) {
        self.id = id
        
        decode(with: dic)
        
    }
    
    private func decode(with dic: [String: Any]) {
        
        if let attributes = properties.attributes {
            decode(attributes: attributes, with: dic)
        }
        
        if let references = properties.references {
            
            for reference in references {
                if let refDic = dic[reference.getKey()] as? [String: Any] {
                    reference.getModel().decode(with: refDic)
                }
            }
            
        }
        
    }
    
    
    private func decode(attributes: [ModelAttribute], with dic: [String: Any]) {
        
        for attribute in attributes {
            switch attribute.getEntryType() {
            case .Int:
                decodeValue(of: attribute, from: dic, class: Int.self)
            case .Double:
                decodeValue(of: attribute, from: dic, class: Double.self)
            case .String:
                decodeValue(of: attribute, from: dic, class: String.self)
            case .Bool:
                decodeValue(of: attribute, from: dic, class: Bool.self)
            case .StringArray:
                decodeValue(of: attribute, from: dic, class: [String].self)
            case .Timestamp:
                decodeValue(of: attribute, from: dic, class: Timestamp.self)
            case .FineMediaType:
                decodeValue(of: attribute, from: dic, enum: FineMediaEnum.self)
            case .RoughMediaType:
                decodeValue(of: attribute, from: dic, enum: RoughMediaEnum.self)
            case .PostReportStatusType:
                decodeValue(of: attribute, from: dic, enum: PostReportStatusEnum.self)
            case .CategoryReportStatusType:
                decodeValue(of: attribute, from: dic, enum: CategoryReportStatusEnum.self)
            }
        }
        
    }
    
}

private func decodeValue<T: DatabaseConvertibleType>(of attribute: ModelAttribute, from dic: [String: Any], class: T.Type) {
    if let value = dic[attribute.getKey()] as? T {
        attribute.setValue(of: value)
    }
}

private func decodeValue<T: DatabaseEnum>(of attribute: ModelAttribute, from dic: [String: Any], enum: T.Type) {
    
    if let value = dic[attribute.getKey()] as? String {
        T.allCases.forEach { (type) in
            if value == type.rawValue {
                return attribute.setValue(of: type)
            }
        }
    }
    
}
//MARK: - Getters
extension Model {
    func getId() -> String { return id ?? "" }
}
