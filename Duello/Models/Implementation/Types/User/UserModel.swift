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
    var userName: UserAttribute { get set }
    
    var instagramName: UserAttribute { get set }
    var snapchatName: UserAttribute { get set }
    var youtubeName: UserAttribute { get set }
    var facebookName: UserAttribute { get set }
    var twitterName: UserAttribute { get set }
    var vimeoName: UserAttribute { get set }
    var tikTokName: UserAttribute { get set }
    var additionalName: UserAttribute { get set }
    
    var youtubeLink: UserAttribute { get set }
    var facebookLink: UserAttribute { get set }
    var vimeoLink: UserAttribute { get set }
    var additionalLink: UserAttribute { get set }
    var instagramLink: UserAttribute { get set }
    var twitterLink: UserAttribute { get set }
    var snapChatLink: UserAttribute { get set }
    
    var imageUrl: UserAttribute { get set }
    
    //MARK: - Getters
    var addedSocialMediaName: Bool { get }
    func hasConnectedLink(for attribute: UserAttribute) -> Bool
    func getAllSocialMediaNames() -> [UserAttribute]
    func getConnectedLink(for attribute: UserAttribute) -> UserAttribute?
    
}

extension UserModel {
    
    //MARK: - Getters
    func getUserName() -> String { return userName.value?.toStringValue() ?? "" }
    func getImageUrl() -> String { return imageUrl.value?.toStringValue() ?? "" }
    
}
