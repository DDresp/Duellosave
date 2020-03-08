//
//  PostDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PostDisplayer {
    
    //MARK: - ChildDisplayers
    var socialMediaDisplayer: SocialMediaDisplayer { get }
    
    //MARK: - Variables
    var index: Int { get }
    var userProfileImageUrl: String  { get }
    var userHasSocialMediaNames: Bool  { get }
    var userName: String  { get }
    var rate: Double { get }
    var title: String { get }
    var description: String { get }
    var postId: String { get }

    //MARK: - Bindables
    var deleteMe: PublishRelay<Int> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var doubleTapped: PublishSubject<Void> { get }
    var likeBlurViewTapped: PublishSubject<Void> { get }
    var showLikeView: BehaviorRelay<Bool> { get }
    
    var didDisappear: PublishRelay<Void> { get }
    var willBeDisplayed: PublishRelay<Void> { get }
    var didExpand: BehaviorRelay<Bool> { get }
    var tappedEllipsis: PublishRelay<Void> { get }

}

