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
    func getUserName() -> String { return userName.getValue() as? String ?? "" }
    
    func getInstagramName() -> String { return instagramName.getValue() as? String ?? "" }
    func getSnapchatName() -> String { return snapchatName.getValue() as? String ?? "" }
    func getYoutubeName() -> String { return youtubeName.getValue() as? String ?? "" }
    func getFacebookName() -> String { return facebookName.getValue() as? String ?? "" }
    func getTwitterName() -> String { return twitterName.getValue() as? String ?? "" }
    func getVimeoName() -> String { return vimeoName.getValue() as? String ?? "" }
    func getTikTokName() -> String { return tikTokName.getValue() as? String ?? "" }
    func getAdditionalName() -> String { return additionalName.getValue() as? String ?? "" }
    
    func getYoutubeLink() -> String { return youtubeLink.getValue() as? String ?? "" }
    func getFacebookLink() -> String { return facebookLink.getValue() as? String ?? "" }
    func getVimeoLink() -> String { return vimeoLink.getValue() as? String ?? "" }
    func getAdditionalLink() -> String { return additionalLink.getValue() as? String ?? "" }
    func getInstagramLink() -> String { return instagramLink.getValue() as? String ?? "" }
    func getTwitterLink() -> String { return twitterLink.getValue() as? String ?? "" }
    func getSnapchatLink() -> String { return snapchatLink.getValue() as? String ?? "" }
    
    func getImageUrl() -> String { return imageUrl.getValue() as? String ?? "" }
    
    func getSocialMediaName(for attribute: UserAttribute) -> String? {
        return attribute.getValue() as? String
    }
    
    func getLinkName(for attribute: UserAttribute) -> String? {
        return attribute.getValue() as? String
    }
    
    func hasLink(for attribute: UserAttribute) -> Bool {
        return getConnectedLink(for: attribute) != nil
    }
    
    func getUserAttributeType(for attribute: UserAttribute) -> UserAttributeType {
        return attribute.getType() as! UserAttributeType
    }
    
    func getIsAvailable(attribute: UserAttribute) -> Bool {
        return attribute.getValue() != nil
    }
    
    //MARK: - Setters
    func setUserName(_ username: String) { self.userName.setValue(of: username)}
    
    func setInstagramName(_ name: String?) { self.instagramName.setValue(of: name) }
    func setSnapchatName(_ name: String?) { self.snapchatName.setValue(of: name)  }
    func setYoutubeName(_ name: String?) { self.youtubeName.setValue(of: name) }
    func setFacebookName(_ name: String?) { self.facebookName.setValue(of: name) }
    func setTwitterName(_ name: String?) { self.twitterName.setValue(of: name) }
    func setVimeoName(_ name: String?) { self.vimeoName.setValue(of: name) }
    func setTikTokName(_ name: String?) { self.tikTokName.setValue(of: name)}
    func setAdditionalName(_ name: String?) { self.additionalName.setValue(of: name) }
    
    func setYoutubeLink(_ link: String?) { self.youtubeLink.setValue(of: link) }
    func setFacebookLink(_ link: String?) { self.facebookLink.setValue(of: link) }
    func setVimeoLink(_ link: String?) { self.vimeoLink.setValue(of: link) }
    func setAdditionalLink(_ link: String?) { self.additionalLink.setValue(of: link) }
    func setInstagramLink(_ link: String?) { self.instagramLink.setValue(of: link) }
    func setTwitterLink(_ link: String?) { self.twitterLink.setValue(of: link) }
    func setSnapchatLink(_ link: String?) { self.snapchatLink.setValue(of: link) }

    func setImageUrl(_ url: String?) { self.imageUrl.setValue(of: url) }
    
}
