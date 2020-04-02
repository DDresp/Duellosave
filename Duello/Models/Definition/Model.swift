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
            case .FineMediaType:
                if let value = attribute.getValue() as? FineMediaType {
                    dictionary[attribute.getKey()] = value.rawValue
                }
            case .RoughMediaType:
                if let value = attribute.getValue() as? RoughMediaType {
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
            case .FineMediaType:
                if let value = dic[attribute.getKey()] as? String {
                    
                    switch value {
                    case FineMediaType.localSingleImage.rawValue:
                        attribute.setValue(of: FineMediaType.localSingleImage)
                    case FineMediaType.localImages.rawValue:
                        attribute.setValue(of: FineMediaType.localImages)
                    case FineMediaType.localVideo.rawValue:
                        attribute.setValue(of: FineMediaType.localVideo)
                    case FineMediaType.instagramVideo.rawValue:
                        attribute.setValue(of: FineMediaType.instagramVideo)
                    case FineMediaType.instagramSingleImage.rawValue:
                        attribute.setValue(of: FineMediaType.instagramSingleImage)
                    case FineMediaType.instagramImages.rawValue:
                        attribute.setValue(of: FineMediaType.instagramImages)
                    default:
                        return
                    }
                }
            case .RoughMediaType:
                if let value = dic[attribute.getKey()] as? String {
                    
                    switch value {
                    case RoughMediaType.Video.rawValue:
                        attribute.setValue(of: RoughMediaType.Video)
                    case RoughMediaType.Image.rawValue:
                        attribute.setValue(of: RoughMediaType.Image)
                    case RoughMediaType.VideoAndImage.rawValue:
                        attribute.setValue(of: RoughMediaType.VideoAndImage)
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

//MARK: - Getters
extension Model {
    func getId() -> String { return id?.toStringValue() ?? "" }
}
