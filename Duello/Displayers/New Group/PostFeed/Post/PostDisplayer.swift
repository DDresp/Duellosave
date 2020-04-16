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
    
    //MARK: - Child Displayers
    var socialMediaDisplayer: SocialMediaDisplayer { get }
    
    //MARK: - Variables
    var index: Int { get }
    var userProfileImageUrl: String  { get }
    var userHasSocialMediaNames: Bool  { get }
    var userName: String  { get }
    var categoryName: String { get }
    var rate: Double { get }
    var title: String { get }
    var description: String { get }
    var postId: String { get }
    var mediaRatio: Double { get }

    //MARK: - Bindables
    var deleteMe: PublishRelay<String> { get }
    var reportMe: PublishRelay<(ReportType, String)> { get }
    
    var isDeactivated: BehaviorRelay<Bool> { get }
    var updateDeactivation: PublishRelay<Int> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var doubleTapped: PublishSubject<Void> { get }
    var likeBlurViewTapped: PublishSubject<Void> { get }
    var showLikeView: BehaviorRelay<Bool> { get }
    
    var didDisappear: PublishRelay<Void> { get }
    var willBeDisplayed: PublishRelay<Void> { get }
    var didExpand: BehaviorRelay<Bool> { get }
    var tappedEllipsis: PublishRelay<Void> { get }

}

