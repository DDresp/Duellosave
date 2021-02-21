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
    func getImageUrl() -> String? { return imageUrl.getValue() as? String ?? "" }
    func getTitle() -> String { return title.getValue() as? String ?? "" }
    func getDescription() -> String { return description.getValue() as? String ?? "" }
    func getCreationDate() -> Double { return creationDate.getValue() as? Double ?? 0 }
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
    
    //MARK: - Setters
    func setImageUrl(_ url: String) { self.imageUrl.setValue(of: url) }
    func setTitle(_ title: String) { self.title.setValue(of: title) }
    func setDescription(_ description: String) { self.description.setValue(of: description)}
    func setCreationDate(_ date: Double) { self.creationDate.setValue(of: date) }
    func setMediaType(_ type: RoughMediaEnum) { self.roughMediaType.setValue(of: type) }
    func setReportStatus(_ status: CategoryReportStatusEnum) { self.reportStatus.setValue(of: status) }
    func setNumberOfPosts(_ number: Int) { self.numberOfPosts.setValue(of: number) }
    func setUID(_ uid: String) { self.uid.setValue(of: uid) }
    func setIsActive(_ isActive: Bool) { self.isActive.setValue(of: isActive) }
    
}
