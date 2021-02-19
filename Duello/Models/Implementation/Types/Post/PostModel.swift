//
//  PostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
//


protocol PostModel: Model {
    
    //MARK: - Variables
    var type: FineMediaEnum { get }
    
    //MARK: - Attributes
    var uid: PostAttribute { get set }
    var cid: PostAttribute { get set }
    var title: PostAttribute{ get set }
    var description: PostAttribute { get set }
    var creationDate: PostAttribute{ get set }
    var likes: PostAttribute { get set }
    var dislikes: PostAttribute { get set }
    var rate: PostAttribute{ get set }
    var typeData: PostAttribute { get set }
    var mediaRatio: PostAttribute { get set }
    var isVerified: PostAttribute { get set }
    var isBlocked: PostAttribute { get set }
    var isDeactivated: PostAttribute { get set }
    var reportStatus: PostAttribute { get set }
    
    var user: PostReference { get set }
    var category: PostReference { get set }

}

extension PostModel {
    
    //MARK: - Getters
    func getId() -> String { return id ?? "" }
    func getUID() -> String { return uid.value as? String ?? "" }
    func getCID() -> String { return cid.value as? String ?? "" }
    func getTitle() -> String { return title.value as? String ?? "" }
    func getDescription() -> String { return description.value as? String ?? "" }
    func getCreationDate() -> Double { return creationDate.value as? Double ?? 0 }
    func getLikes() -> Int { return likes.value as? Int ?? 0 }
    func getDislikes() -> Int { return dislikes.value as? Int ?? 0 }
    func getRate() -> Double { return rate.value as? Double ?? 0 }
    func getMediaRatio() -> Double { return mediaRatio.value as? Double ?? 1}
    
    func getIsVerified() -> Bool { return isVerified.value as? Bool ?? false }
    func getIsBlocked() -> Bool { return isBlocked.value as? Bool ?? false }
    func getIsDeactivated() -> Bool { return isDeactivated.value as? Bool ?? false }
    
    func getReportStatus() -> PostReportStatusEnum { return reportStatus.getValue() as? PostReportStatusEnum ?? PostReportStatusEnum.noReport }
    func getUser() -> UserModel { return user.getModel() as? User ?? User() }
    func getCategory() -> CategoryModel { return category.getModel() as? Category ?? Category() }
    
}
