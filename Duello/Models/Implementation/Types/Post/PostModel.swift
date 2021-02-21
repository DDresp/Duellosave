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
    
    //MARK: - Setters
    func setUID(_ uid: String?) { self.uid.value = uid }
    func setCID(_ cid: String?) { self.cid.value = cid }
    func setTitle(_ title: String?) { self.title.value = title }
    func setDescription(_ description: String?) { self.description.value = description }
    func setCreationDate(_ date: Double?) { self.creationDate.value = date }
    func setLikes(_ likes: Int?) { self.likes.value = likes }
    func setDislikes(_ dislikes: Int?) { self.dislikes.value = dislikes }
    func setRate(_ rate: Double?) { self.rate.value = rate }
    func setMediaRatio(_ ratio: Double?) { self.mediaRatio.value = ratio ?? 1 }
    
    func setIsVerified(_ isVerified: Bool?) { self.isVerified.value = isVerified }
    func setIsBlocked(_ isBlocked: Bool?) { self.isBlocked.value = isBlocked }
    func setIsDeactivated(_ isDeactivated: Bool?) { self.isDeactivated.value = isDeactivated }
    
    func setReportStatus(_ status: PostReportStatusEnum?) { self.reportStatus.value = status }
    func setUser(_ user: UserModel) { self.user.model = user }
    func setCategory(_ category: CategoryModel) { self.category.model = category }
}
