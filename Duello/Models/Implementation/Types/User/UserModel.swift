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
    var snapchatLink: UserAttribute { get set }
    
    var imageUrl: UserAttribute { get set }
    
    //MARK: - Getters
    var addedSocialMediaName: Bool { get }
    func hasConnectedLink(for attribute: UserAttribute) -> Bool
    func getAllSocialMediaNameAttributes() -> [UserAttribute]
    func getConnectedLink(for attribute: UserAttribute) -> UserAttribute?
    
}

extension UserModel {
    
    //MARK: - Getters
    func getUserName() -> String { return userName.value as? String ?? "" }
    
    func getInstagramName() -> String { return instagramName.value as? String ?? "" }
    func getSnapchatName() -> String { return snapchatName.value as? String ?? "" }
    func getYoutubeName() -> String { return youtubeName.value as? String ?? "" }
    func getFacebookName() -> String { return facebookName.value as? String ?? "" }
    func getTwitterName() -> String { return twitterName.value as? String ?? "" }
    func getVimeoName() -> String { return vimeoName.value as? String ?? "" }
    func getTikTokName() -> String { return tikTokName.value as? String ?? "" }
    func getAdditionalName() -> String { return additionalName.value as? String ?? "" }
    
    func getYoutubeLink() -> String { return youtubeLink.value as? String ?? "" }
    func getFacebookLink() -> String { return facebookLink.value as? String ?? "" }
    func getVimeoLink() -> String { return vimeoLink.value as? String ?? "" }
    func getAdditionalLink() -> String { return additionalLink.value as? String ?? "" }
    func getInstagramLink() -> String { return instagramLink.value as? String ?? "" }
    func getTwitterLink() -> String { return twitterLink.value as? String ?? "" }
    func getSnapchatLink() -> String { return snapchatLink.value as? String ?? "" }
    
    func getImageUrl() -> String { return imageUrl.value as? String ?? "" }
    
    func getSocialMediaName(for attribute: UserAttribute) -> String? {
        return attribute.value as? String
    }
    
    func getLinkName(for attribute: UserAttribute) -> String? {
        return attribute.value as? String
    }
    
}
