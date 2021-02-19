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
    func getImageUrl() -> String? { return imageUrl.value?.toStringValue() }
    func getTitle() -> String { return title.value?.toStringValue() ?? "" }
    func getDescription() -> String { return description.value?.toStringValue() ?? "" }
    func getCreationDate() -> Double { return Double(creationDate.value?.toStringValue() ?? "0") ?? 0 }
    func getReportStatus() -> CategoryReportStatusEnum { return reportStatus.getValue() as? CategoryReportStatusEnum ?? CategoryReportStatusEnum.noReport }
    func getNumberOfPosts() -> Int { return numberOfPosts.getValue() as? Int ?? 0 }
    func getUID() -> String { return uid.getValue() as? String ?? "" }
    func getIsActive() -> Bool { return isActive.getValue() as? Bool ?? false }
    
    func allowsVideos() -> Bool {
        guard let mediaType = roughMediaType.getValue() as? RoughMediaEnum else { return false }
        switch mediaType {
        case .image: return false
        case .videoAndImage, .video: return true
        }
        
    }
    func allowsImages() -> Bool {
        guard let mediaType = roughMediaType.getValue() as? RoughMediaEnum else { return false }
        switch mediaType {
        case .image, .videoAndImage: return true
        case .video: return false
        }
    }
}
