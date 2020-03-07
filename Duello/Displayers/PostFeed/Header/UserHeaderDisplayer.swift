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
    var socialMediaViewModel: SocialMediaDisplayer { get }
    
    //MARK: - Variables
    var imageUrl: String? { get }
    var userName: String? { get }
    var hasSocialMediaNames: Bool { get }
    
    //MARK: - Bindables
    var score: BehaviorRelay<Double?> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var imageTapped: PublishRelay<Void> { get }
    var cleanUser: PublishRelay<Void> { get }
    var reload: PublishRelay<Void> { get }
    
}
