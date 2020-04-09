//
//  UserModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

protocol UserModel: Model {
    
    //MARK: - Variables
    var score: Double? { get set }
    
    //MARK: - Attributes
    var userName: UserSingleAttribute { get set }
    
    var instagramName: UserSingleAttribute { get set }
    var snapchatName: UserSingleAttribute { get set }
    var youtubeName: UserSingleAttribute { get set }
    var facebookName: UserSingleAttribute { get set }
    var twitterName: UserSingleAttribute { get set }
    var vimeoName: UserSingleAttribute { get set }
    var tikTokName: UserSingleAttribute { get set }
    var additionalName: UserSingleAttribute { get set }
    
    var youtubeLink: UserSingleAttribute { get set }
    var facebookLink: UserSingleAttribute { get set }
    var vimeoLink: UserSingleAttribute { get set }
    var additionalLink: UserSingleAttribute { get set }
    var instagramLink: UserSingleAttribute { get set }
    var twitterLink: UserSingleAttribute { get set }
    var snapChatLink: UserSingleAttribute { get set }
    
    var imageUrl: UserSingleAttribute { get set }
    
    //MARK: - Getters
    var addedSocialMediaName: Bool { get }
    func hasConnectedLink(for attribute: UserSingleAttribute) -> Bool
    func getAllSocialMediaNames() -> [UserSingleAttribute]
    func getConnectedLink(for attribute: UserSingleAttribute) -> UserSingleAttribute?
    
}

extension UserModel {
    
    //MARK: - Getters
    func getUserName() -> String { return userName.value?.toStringValue() ?? "" }
    func getImageUrl() -> String { return imageUrl.value?.toStringValue() ?? "" }
    
}
