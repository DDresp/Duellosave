//
//  Model.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

protocol Model {
    
    var id: String? { get set }
    
    func getMapAttributes() -> [MapAttribute]?
    func getSingleAttributes() -> [SingleAttribute]

}

extension Model {
    
    func getMapAttributes() -> [MapAttribute]? {
        return nil
    }
    
}

//MARK: - Encoding
extension Model {
    
    func getUploadDictionary() -> [String: Any] {
        
        let allSingleAttributes = getSingleAttributes()
        var dictionary = makeDictionary(attributes: allSingleAttributes)
        
        guard let allMapAttributes = getMapAttributes() else { return dictionary }
        var mapDictionary = [String: Any]()
        for mapAttribute in allMapAttributes {
            mapDictionary[mapAttribute.getKey()] = mapAttribute.getModel().getUploadDictionary()
        }
        
        dictionary += mapDictionary
        
        return dictionary
    }

    private func makeDictionary(attributes: [SingleAttribute]) -> [String: Any] {
        var dictionary = [String: Any]()
        for attribute in attributes {
            
            switch attribute.getEntryType() {
            case .Int:
                if let value = attribute.getValue() as? Int {
                    dictionary[attribute.getKey()] = value
                }
            case .Double:
                if let value = attribute.getValue() as? Double {
                    dictionary[attribute.getKey()] = value
                }
            case .String:
                if let value = attribute.getValue() as? String {
                    dictionary[attribute.getKey()] = value
                }
            case .MediaType:
                if let value = attribute.getValue() as? MediaType {
                    dictionary[attribute.getKey()] = value.rawValue
                }
            case .Bool:
                if let value = attribute.getValue() as? Bool {
                    dictionary[attribute.getKey()] = value ? 1 : 0
                }
            }
        }
        
        return dictionary
        
    }
}

//MARK: - Decoding
extension Model {
    
    mutating func configure(with dic: [String: Any], id: String?) {
        self.id = id
        configure(with: dic)
    }
    
    func configure(with dic: [String: Any]) {
        
        let allSingleAttributes = getSingleAttributes()
        for attribute in allSingleAttributes {
            switch attribute.getEntryType() {
            case .Int:
                if let value = dic[attribute.getKey()] as? Int {
                    attribute.setValue(of: value)
                }
            case .Double:
                if let value = dic[attribute.getKey()] as? Double {
                    attribute.setValue(of: value)
                }
            case .String:
                if let value = dic[attribute.getKey()] as? String {
                    attribute.setValue(of: value)
                }
            case .MediaType:
                if let value = dic[attribute.getKey()] as? String {
                    
                    switch value {
                    case MediaType.localSingleImage.rawValue:
                        attribute.setValue(of: MediaType.localSingleImage)
                    case MediaType.localImages.rawValue:
                        attribute.setValue(of: MediaType.localImages)
                    case MediaType.localVideo.rawValue:
                        attribute.setValue(of: MediaType.localVideo)
                    case MediaType.instagramVideo.rawValue:
                        attribute.setValue(of: MediaType.instagramVideo)
                    case MediaType.instagramSingleImage.rawValue:
                        attribute.setValue(of: MediaType.instagramSingleImage)
                    case MediaType.instagramImages.rawValue:
                        attribute.setValue(of: MediaType.instagramImages)
                    default:
                        return
                        
                    }
                }
            case .Bool:
                if let value = dic[attribute.getKey()] as? Int, value == 0 {
                    attribute.setValue(of: false)
                } else {
                    attribute.setValue(of: true)
                }
            }
        }
        
        guard let mapAttributes = getMapAttributes() else { return }
        for mapAttribute in mapAttributes {
            if let mapDic = dic[mapAttribute.getKey()] as? [String: Any] {
                mapAttribute.getModel().configure(with: mapDic)
            }
        }
    }
}
