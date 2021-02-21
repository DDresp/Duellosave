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
    
    func getUID() -> String { return uid.getValue() as? String ?? "" }
    func getCID() -> String { return cid.getValue() as? String ?? "" }
    func getTitle() -> String { return title.getValue() as? String ?? "" }
    func getDescription() -> String { return description.getValue() as? String ?? "" }
    func getCreationDate() -> Double { return creationDate.getValue() as? Double ?? 0 }
    func getLikes() -> Int { return likes.getValue() as? Int ?? 0 }
    func getDislikes() -> Int { return dislikes.getValue() as? Int ?? 0 }
    func getRate() -> Double { return rate.getValue() as? Double ?? 0 }
    func getMediaRatio() -> Double { return mediaRatio.getValue() as? Double ?? 1}
    
    func getIsVerified() -> Bool { return isVerified.getValue() as? Bool ?? false }
    func getIsBlocked() -> Bool { return isBlocked.getValue() as? Bool ?? false }
    func getIsDeactivated() -> Bool { return isDeactivated.getValue() as? Bool ?? false }
    
    func getReportStatus() -> PostReportStatusEnum { return reportStatus.getValue() as? PostReportStatusEnum ?? PostReportStatusEnum.noReport }
    func getUser() -> UserModel { return user.getModel() as? User ?? User() }
    func getCategory() -> CategoryModel { return category.getModel() as? Category ?? Category() }
    
    //MARK: - Setters
    func setUID(_ uid: String?) { self.uid.setValue(of: uid) }
    func setCID(_ cid: String?) { self.cid.setValue(of: cid) }
    func setTitle(_ title: String?) { self.title.setValue(of: title) }
    func setDescription(_ description: String?) { self.description.setValue(of: description) }
    func setCreationDate(_ date: Double?) { self.creationDate.setValue(of: date) }
    func setLikes(_ likes: Int?) { self.likes.setValue(of: likes) }
    func setDislikes(_ dislikes: Int?) { self.dislikes.setValue(of: dislikes) }
    func setRate(_ rate: Double?) { self.rate.setValue(of: rate) }
    func setMediaRatio(_ ratio: Double?) { self.mediaRatio.setValue(of: ratio ?? 1) }
    
    func setIsVerified(_ isVerified: Bool?) { self.isVerified.setValue(of: isVerified) }
    func setIsBlocked(_ isBlocked: Bool?) { self.isBlocked.setValue(of: isBlocked) }
    func setIsDeactivated(_ isDeactivated: Bool?) { self.isDeactivated.setValue(of: isDeactivated) }
    
    func setReportStatus(_ status: PostReportStatusEnum?) { self.reportStatus.setValue(of: status) }
    func setUser(_ user: UserModel) { self.user.model = user }
    func setCategory(_ category: CategoryModel) { self.category.model = category }
}
