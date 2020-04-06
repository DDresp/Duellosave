//
//  CategoryModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol CategoryModel: Model {
    
    //MARK: - Attributes
    var title: CategorySingleAttribute { get set }
    var description: CategorySingleAttribute { get set }
    var creationDate: CategorySingleAttribute{ get set }
    var roughMediaType: CategorySingleAttribute { get set }

}

extension CategoryModel {
    
    //MARK: - Getters
    func getTitle() -> String { return title.value?.toStringValue() ?? "" }
    func getDescription() -> String { return description.value?.toStringValue() ?? "" }
    func getCreationDate() -> Double { return Double(creationDate.value?.toStringValue() ?? "0") ?? 0 }
    
    func allowsVideos() -> Bool {
        guard let mediaType = roughMediaType.getValue() as? RoughMediaType else { return false }
        switch mediaType {
        case .Image: return false
        case .VideoAndImage, .Video: return true
        }
        
    }
    func allowsImages() -> Bool {
        guard let mediaType = roughMediaType.getValue() as? RoughMediaType else { return false }
        switch mediaType {
        case .Image, .VideoAndImage: return true
        case .Video: return false
        }
    }
}
