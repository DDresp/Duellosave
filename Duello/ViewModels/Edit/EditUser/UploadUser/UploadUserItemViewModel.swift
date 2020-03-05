//
//  UploadUserItemViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class UploadUserItemViewModel: UploadUserItemDisplayer {
    
    //MARK: - Definitions
    enum ItemType: String {
        case username
        case instagram
        case snapchat
        case youtube
        case facebook
        case twitter
        case vimeo
        case tiktok
        case additionalLink
    }
    
    //MARK: - Variables
    let itemType: ItemType
    let maxNameCharacters: Int = 30
    let maxLinkCharacters: Int = 200
    
    //MARK: - Bindables
    var name: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var nameIsEdited: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var addedName: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var nameTooLong: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var link: BehaviorRelay<String?>?
    var linkIsEdited: BehaviorRelay<Bool>?
    var linkHasName: BehaviorRelay<Bool>?
    var linkTooLong: BehaviorRelay<Bool>?
    
    //MARK: - Setup
    init(itemType: ItemType) {
        self.itemType = itemType
        setupBindablesFromSelf()
    }
    
    //MARK: - Getters
    var title: String {
        switch itemType {
        case .username: return "USERNAME"
        case .instagram: return "INSTAGRAM"
        case .snapchat: return "SNAPCHAT"
        case .youtube: return "YOUTUBE"
        case .facebook: return "FACEBOOK"
        case .twitter: return "TWITTER"
        case .vimeo: return "VIMEO"
        case .tiktok: return "TIKTOK"
        case .additionalLink: return "ADDITIONAL LINK"
        }
    }
    
    var hasDefaultLink: Bool {
        switch itemType {
        case .instagram, .snapchat, .twitter: return true
        default: return false
        }
    }
    
    var isOptional: Bool {
        switch itemType {
        case .username: return false
        default: return true
        }
    }
    
    var placeholderName: String {
        switch itemType {
        case .username: return "username"
        case .instagram: return "instagram name"
        case .snapchat: return "snapchat name"
        case .youtube: return "youtube name"
        case .facebook: return "facebook name"
        case .twitter: return "twitter name"
        case .vimeo: return "vimeo name"
        case .tiktok: return "tiktok name"
        case .additionalLink: return "additional link title"
        }
    }
    
    var namePlaceholderString: String {
        if isOptional {
            return "Add your \(placeholderName) (optional)"
        } else {
            return "Add your \(placeholderName)"
        }
    }
    
    var iconName: String? {
        switch itemType {
        case .username: return nil
        case .instagram: return "instagram_hex_icon"
        case .snapchat: return "flckr_hex_icon"
        case .youtube: return "tube_hex_icon"
        case .facebook: return "facebook_hex_icon"
        case .twitter: return "twitter_hex_icon"
        case .vimeo: return "vimeo_hex_icon"
        case .tiktok: return "tumblr_hex_icon"
        case .additionalLink: return "linkedin_hex_icon"
        }
    }
    
    var hasIcon: Bool {
        if let _ = iconName {
            return true
        } else {
            return false
        }
    }
    
    //Could have a link and no link prefix
    var userCanAddLink: Bool {
        switch itemType {
        case .vimeo, .facebook, .youtube, .additionalLink: return true
        default: return false
        }
    }
    
    var linkPrefix: String? {
        switch itemType {
        case .youtube: return "https://www.youtube.com/"
        case .facebook: return "https://www.facebook.com/"
        case .vimeo: return "https://vimeo.com/"
        case .additionalLink: return "https://"
        default: return nil
        }
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromSelf() {
        setupNameBindables()
        if userCanAddLink {
            setupLinkBindables()
        }
    }
    
    private func setupNameBindables() {
        name.asObservable().map { (name) -> Bool in
            guard let name = name else { return false }
            return name.count > 0
            }.bind(to: nameIsEdited).disposed(by: disposeBag)
        
        name.asObservable().map { [weak self] (name) -> Bool in
            guard let self = self else { return true }
            if self.isOptional { return true }
            if let name = name, name.count > 0 { return true }
            return false
            }.bind(to: addedName).disposed(by: disposeBag)
        
        name.asObservable().map { [weak self] (name) -> Bool in
            guard let name = name else { return false }
            guard let self = self else { return false }
            return name.count > self.maxNameCharacters
            }.bind(to: nameTooLong).disposed(by: disposeBag)
    }
    
    private func setupLinkBindables() {
        
        link = BehaviorRelay<String?>(value: linkPrefix)
        linkIsEdited = BehaviorRelay<Bool>(value: false)
        linkHasName = BehaviorRelay<Bool>(value: true)
        linkTooLong = BehaviorRelay<Bool>(value: false)
        
        link!.asObservable().map { [weak self] (link) -> Bool in
            guard let link = link else { return false }
            guard let linkPrefix = self?.linkPrefix else { return true }
            return link.count > linkPrefix.count
            }.bind(to: linkIsEdited!).disposed(by: disposeBag)
        
        link!.asObservable().map { [weak self] (link) -> Bool in
            guard let link = link else { return false }
            guard let self = self else { return false }
            return link.count > self.maxLinkCharacters
            }.bind(to: linkTooLong!).disposed(by: disposeBag)
        
        Observable.combineLatest(linkIsEdited!, name) { (linkIsEdited, name) -> Bool in
            //if there is a link, there should be a name as well
            if linkIsEdited == false { return true }
            if let name = name, name.count > 0 { return true }
            return false
            }.bind(to: linkHasName!).disposed(by: disposeBag)
    }
    
}
