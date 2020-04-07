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
    var uid: PostSingleAttribute { get set }
    var cid: PostSingleAttribute { get set }
    var title: PostSingleAttribute{ get set }
    var description: PostSingleAttribute { get set }
    var creationDate: PostSingleAttribute{ get set }
    var likes: PostSingleAttribute { get set }
    var dislikes: PostSingleAttribute { get set }
    var rate: PostSingleAttribute{ get set }
    var typeData: PostSingleAttribute { get set }
    var mediaRatio: PostSingleAttribute { get set }
    var isDeactivated: PostSingleAttribute { get set }
    var user: PostMapAttribute { get set }
    var category: PostMapAttribute { get set }

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
    func getUser() -> UserModel { return user.getModel() as? User ?? User() }
    func getCategory() -> CategoryModel { return category.getModel() as? Category ?? Category() }
    
}
