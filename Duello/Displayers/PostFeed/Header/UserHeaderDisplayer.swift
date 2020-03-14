//
//  UserHeaderDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UserHeaderDisplayer {
    
    //MARK: - Model
    var user: BehaviorRelay<UserModel?> { get }
    
    //MARK: - Child Displayers
    var socialMediaDisplayer: SocialMediaDisplayer { get }
    
    //MARK: - Variable
    var score: Double? { get set }
    
    //MARK: - Bindables
    var imageTapped: PublishRelay<Void> { get }
    var reload: PublishRelay<Void> { get }
    var animateScore: PublishRelay<Void> { get } 

    //MARK: - Getters
    var imageUrl: String? { get }
    var userName: String? { get }
    var hasSocialMediaNames: Bool { get }
    
}
