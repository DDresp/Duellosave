//
//  PostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class PostViewModel: PostDisplayer {
    
    //MARK: - Models
    let user: UserModel
    let post: PostModel
    
    //MARK: - ChildViewModels
    var socialMediaDisplayer: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: false)
    
    //MARK: - Variables
    var index: Int
    var postId: String
    var rate: Double
    var title: String
    var description: String
    
    //MARK: - Bindables
    //from UI
    var didExpand: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var tappedEllipsis: PublishRelay<Void> = PublishRelay<Void>()
    var doubleTapped: PublishSubject<Void> = PublishSubject<Void>()
    var likeBlurViewTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    //to UI
    var showLikeView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    
    //from Parent
    var didDisappear: PublishRelay<Void> = PublishRelay()
    var willBeDisplayed: PublishRelay<Void> = PublishRelay()
    
    //to Parent
    var deleteMe: PublishRelay<Int> = PublishRelay<Int>()
    
    //MARK: - Setup
    init(user: UserModel, post: PostModel, index: Int) {
        self.user = user
        self.post = post
        self.index = index
        self.postId = post.getId()
        self.rate = post.getRate()
        self.description = post.getDescription()
        self.title = post.getTitle()
        socialMediaDisplayer.user.accept(user)
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    var userProfileImageUrl: String { return user.imageUrl.value?.toStringValue() ?? "" }
    var userHasSocialMediaNames: Bool { return user.addedSocialMediaName }
    var userName: String { return user.userName.value?.toStringValue() ?? "" }
    
    var actionSheet: ActionSheet {
        
        let deleteWarning = ActionWarning(title: "Warning", message: "Do you really want to delete the post?")
        let deleteAction = AlertAction(title: "Delete", actionWarning: deleteWarning) { [weak self] () in
            guard let index = self?.index else { return }
            self?.deleteMe.accept(index)
        }
        
        let likeViewAction = AlertAction(title: showLikeView.value ? "Dismiss Score" : "Show Score") { [weak self] () in
            guard let showsLikeViewValue = self?.showLikeView.value else { return }
            self?.showLikeView.accept(!showsLikeViewValue)
        }
        return ActionSheet(actionHeader: nil, actionMessage: "choose Options", actions: [likeViewAction, deleteAction])
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        tappedEllipsis.asObservable().share().asObservable().map { [weak self] (_) -> ActionSheet? in
            return self?.actionSheet
            }
            .flatMap { Observable.from(optional: $0) }
            .bind(to: showActionSheet).disposed(by: disposeBag)
        
        Observable.merge([doubleTapped, likeBlurViewTapped]).withLatestFrom(showLikeView).map { (showLikeView) -> Bool in
            return !showLikeView
            }.bind(to: showLikeView).disposed(by: disposeBag)
        
        didDisappear.map { (_) -> Bool in
            return false
            }.bind(to: showLikeView).disposed(by: disposeBag)

    }
    
    deinit {
        print("debug: Deinit POSTVIEWMODEL")
    }
    
}
