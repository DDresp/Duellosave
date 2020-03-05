//
//  SocialMediaDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SocialMediaDisplayer {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> { get }
    
    //MARK: - Variables
    var isDarkMode: Bool { get }
    var sizes: [Int: CGSize] { get set }
    
    //MARK: - Bindables
    var cleanCache: PublishRelay<Void> { get }
    var reloadData: BehaviorRelay<Void> { get }
    var selectedItemIndex: PublishRelay<Int?> { get }
    var selectedLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    
    //MARK: - Getters
    var numberOfItemDisplayers: Int { get }
    func getItemDisplayer(for indexPath: IndexPath) -> SocialMediaItemDisplayer
    func itemHasLink(for indexPath: IndexPath) -> Bool
        
}
