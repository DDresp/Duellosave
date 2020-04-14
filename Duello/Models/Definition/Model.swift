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
    
    func getReferences() -> [ModelReference]?
    func getAttributes() -> [ModelAttribute]

}

extension Model {
    
    func getReferences() -> [ModelReference]? {
        return nil
    }
    
}

//MARK: - Encoding
extension Model {
    
    func getUploadDictionary() -> [String: Any] {
        
        let attributes = getAttributes()
        var dictionary = makeDictionary(attributes: attributes)
        
        guard let references = getReferences() else { return dictionary }
        var referenceDictionary = [String: Any]()
        for reference in references {
            referenceDictionary[reference.getKey()] = reference.getModel().getUploadDictionary()
        }
        
        dictionary += referenceDictionary
        
        return dictionary
    }

    private func makeDictionary(attributes: [ModelAttribute]) -> [String: Any] {
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
            case .StringArray:
                if let value = attribute.getValue() as? [String] {
                    dictionary[attribute.getKey()] = value
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
        
        let attributes = getAttributes()
        for attribute in attributes {
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
            case .StringArray:
                if let value = dic[attribute.getKey()] as? [String] {
                    attribute.setValue(of: value)
                }
            }
        }
        
        guard let references = getReferences() else { return }
        for reference in references {
            if let refDic = dic[reference.getKey()] as? [String: Any] {
                reference.getModel().configure(with: refDic)
            }
        }
    }
}

//MARK: - Getters
extension Model {
    func getId() -> String { return id?.toStringValue() ?? "" }
}
