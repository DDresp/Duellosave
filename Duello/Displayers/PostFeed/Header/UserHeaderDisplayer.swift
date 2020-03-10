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
    
    //MARK: - ChildDisplayers
    var socialMediaDisplayer: SocialMediaDisplayer { get }
    
    //MARK: - Variable
    var score: Double? { get set } //Developing
    
    //MARK: - Bindables
//    var score: BehaviorRelay<Double?> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var imageTapped: PublishRelay<Void> { get }
    var reload: PublishRelay<Void> { get }
    var animateScore: PublishRelay<Void> { get } //developing
    var didAppear: PublishRelay<Void> { get } //Fixing Animation
    
    //MARK: - Getters
    var imageUrl: String? { get }
    var userName: String? { get }
    var hasSocialMediaNames: Bool { get }
    
}
