//
//  CategoryModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol CategoryModel: Model {
    
    //MARK: - Attributes
    var imageUrl: CategoryAttribute { get set }
    var title: CategoryAttribute { get set }
    var description: CategoryAttribute { get set }
    var creationDate: CategoryAttribute{ get set }
    var roughMediaType: CategoryAttribute { get set }
    var reportStatus: CategoryAttribute { get set }
    var numberOfPosts: CategoryAttribute { get set }
    var uid: CategoryAttribute { get set }
    var isActive: CategoryAttribute { get set }

}

extension CategoryModel {
    
    //MARK: - Getters
    func getImageUrl() -> String? { return imageUrl.value as? String ?? "" }
    func getTitle() -> String { return title.value as? String ?? "" }
    func getDescription() -> String { return description.value as? String ?? "" }
    func getCreationDate() -> Double { return creationDate.value as? Double ?? 0 }
    func getReportStatus() -> CategoryReportStatusEnum { return reportStatus.value as? CategoryReportStatusEnum ?? CategoryReportStatusEnum.noReport }
    func getNumberOfPosts() -> Int { return numberOfPosts.value as? Int ?? 0 }
    func getUID() -> String { return uid.value as? String ?? "" }
    func getIsActive() -> Bool { return isActive.value as? Bool ?? false }
    
    func allowsVideos() -> Bool {
        guard let mediaType = roughMediaType.value as? RoughMediaEnum else { return false }
        switch mediaType {
        case .image: return false
        case .videoAndImage, .video: return true
        }
        
    }
    func allowsImages() -> Bool {
        guard let mediaType = roughMediaType.value as? RoughMediaEnum else { return false }
        switch mediaType {
        case .image, .videoAndImage: return true
        case .video: return false
        }
    }
}
