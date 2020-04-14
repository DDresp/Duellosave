//
//  PostModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol PostModel: Model {
    
    //MARK: - Variables
    var type: FineMediaType { get }
    
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
    var isDeactivated: PostAttribute { get set }
    var isInappropriate: PostAttribute { get set }
    var isInWrongCategory: PostAttribute { get set }
    var isFromFakeUser: PostAttribute { get set }
    var user: PostReference { get set }
    var category: PostReference { get set }

}

extension PostModel {
    
    //MARK: - Getters
    func getId() -> String { return id?.toStringValue() ?? "" }
    func getUID() -> String { return uid.value?.toStringValue() ?? "" }
    func getCID() -> String { return cid.value?.toStringValue() ?? "" }
    func getTitle() -> String { return title.value?.toStringValue() ?? "" }
    func getDescription() -> String { return description.value?.toStringValue() ?? "" }
    func getCreationDate() -> Double { return Double(creationDate.value?.toStringValue() ?? "0") ?? 0 }
    func getLikes() -> Double { return Double(likes.value?.toStringValue() ?? "0") ?? 0 }
    func getDislikes() -> Double { return Double(dislikes.value?.toStringValue() ?? "0") ?? 0 }
    func getRate() -> Double { return Double(rate.value?.toStringValue() ?? "0") ?? 0 }
    func getMediaRatio() -> Double { return Double(mediaRatio.value?.toStringValue() ?? "1") ?? 1}
    func getIsDeactivated() -> Bool { return isDeactivated.value?.toStringValue() == "0" ? false : true }
    func getIsInappropriate() -> Bool { return isInappropriate.value?.toStringValue() == "0" ? false : true }
    func getIsInWrongCategory() -> Bool { return isInWrongCategory.value?.toStringValue() == "0" ? false : true }
    func getIsFromFakeUser() -> Bool { return isFromFakeUser.value?.toStringValue() == "0" ? false : true }
    func getUser() -> UserModel { return user.getModel() as? User ?? User() }
    func getCategory() -> CategoryModel { return category.getModel() as? Category ?? Category() }
    
}
