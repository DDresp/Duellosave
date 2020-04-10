//
//  PostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

struct PostViewModelOptions {
    var allowsDelete: Bool = false
    var allowsReport: Bool = false
}

class PostViewModel: PostDisplayer {
    
    //MARK: - Models
    let post: PostModel
    
    //MARK: - ChildViewModels
    var socialMediaDisplayer: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: false)
    
    //MARK: - Variables
    var index: Int
    var postId: String
    var rate: Double
    var title: String
    var description: String
    var mediaRatio: Double
    var userProfileImageUrl: String
    var userHasSocialMediaNames: Bool
    var userName: String
    var categoryName: String
    
    let options: PostViewModelOptions
    
    
    //MARK: - Bindables
    //from UI
    var didExpand: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var tappedEllipsis: PublishRelay<Void> = PublishRelay<Void>()
    var doubleTapped: PublishSubject<Void> = PublishSubject<Void>()
    var likeBlurViewTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    //to UI
    var showLikeView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var isDeactivated: BehaviorRelay<Bool>
    
    //from Parent
    var didDisappear: PublishRelay<Void> = PublishRelay()
    var willBeDisplayed: PublishRelay<Void> = PublishRelay()
    
    //to Parent
    var updateDeactivation: PublishRelay<Int> = PublishRelay<Int>()
    var deleteMe: PublishRelay<String> = PublishRelay<String>()
    var reportMe: PublishRelay<String> = PublishRelay<String>()
    
    //MARK: - Setup
    init(post: PostModel, index: Int, options: PostViewModelOptions) {
        self.post = post
        self.index = index
        self.postId = post.getId()
        self.rate = post.getRate()
        self.description = post.getDescription()
        self.title = post.getTitle()
        self.mediaRatio = post.getMediaRatio()
        self.isDeactivated = BehaviorRelay(value: post.getIsDeactivated())
        self.userProfileImageUrl = post.getUser().imageUrl.value?.toStringValue() ?? ""
        self.userHasSocialMediaNames = post.getUser().addedSocialMediaName
        self.userName = post.getUser().userName.value?.toStringValue() ?? ""
        self.categoryName = post.getCategory().title.value?.toStringValue() ?? ""
        
        self.options = options
        
        socialMediaDisplayer.user.accept(post.getUser())
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    func getActions() -> [AlertAction] {
        var actions = [AlertAction]()
        
        let likeViewAction = AlertAction(title: showLikeView.value ? "Dismiss Score" : "Show Score") { [weak self] () in
            guard let showsLikeViewValue = self?.showLikeView.value else { return }
            self?.showLikeView.accept(!showsLikeViewValue)
        }
        actions.append(likeViewAction)
        
        if options.allowsDelete {
            let deleteWarning = ActionWarning(title: "Warning", message: "Do you really want to delete the post?")
            let deleteAction = AlertAction(title: "Delete", actionWarning: deleteWarning) { [weak self] () in
                guard let postId = self?.postId else { return }
                self?.deleteMe.accept(postId)
            }
            actions.append(deleteAction)
        }
        
        if options.allowsReport {
            let reportAction = AlertAction(title: "Report") { [weak self] () in
                guard let postId = self?.postId else { return }
                self?.reportMe.accept(postId)
            }
            actions.append(reportAction)
        }
        
        return actions
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        tappedEllipsis.share().asObservable().map { [weak self] (_) -> ActionSheet? in
            guard let actions = self?.getActions() else { return nil }
            let actionSheet = ActionSheet(actionHeader: nil, actionMessage: "select option", actions: actions)
            return actionSheet
            }
            .flatMap { Observable.from(optional: $0) }
            .bind(to: showActionSheet).disposed(by: disposeBag)
        
        Observable.merge([doubleTapped, likeBlurViewTapped]).withLatestFrom(showLikeView).map { (showLikeView) -> Bool in
            return !showLikeView
        }.bind(to: showLikeView).disposed(by: disposeBag)
        
        didDisappear.map { (_) -> Bool in
            return false
        }.bind(to: showLikeView).disposed(by: disposeBag)
        
        //Checks if the associated model already captures the deactivation state of the PostDisplayer correctly
        isDeactivated.filter { [weak self] (isDeactivated) -> Bool in
            return isDeactivated != self?.post.getIsDeactivated()
        }.do(onNext: { [weak self] (isDeactivated) in
            self?.post.isDeactivated.setValue(of: isDeactivated)
        }).map { [weak self] (isDeactivated) -> Int in
            self?.post.isDeactivated.setValue(of: isDeactivated)
            return self?.index ?? 0
        }.bind(to: updateDeactivation).disposed(by: disposeBag)
        
        reportMe.subscribe(onNext: { [weak self] (_) in
            
            var actions = [AlertAction]()
            
            let inappropriatePostReport = AlertAction(title: "Inappropriate Post") {
                print("debug: inappropriate post")
            }
            
            let fakeUserReport = AlertAction(title: "Fake User") {
                print("debug: fake user")
            }
            
            let wrongCategoryReport = AlertAction(title: "Wrong Category") {
                print("debug: wrong category")
            }
            
            actions.append(contentsOf: [inappropriatePostReport, fakeUserReport, wrongCategoryReport])
            
            let actionSheet = ActionSheet(actionHeader: "report", actionMessage: nil, actions: actions)
            self?.showActionSheet.accept(actionSheet)
            
        }).disposed(by: disposeBag)
        
    }
    
}


//
//import RxSwift
//import RxCocoa
//
//class PostViewModel: PostDisplayer {
//
//    //MARK: - Models
//    let post: PostModel
//
//    //MARK: - ChildViewModels
//    var socialMediaDisplayer: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: false)
//
//    //MARK: - Variables
//    var index: Int
//    var postId: String
//    var rate: Double
//    var title: String
//    var description: String
//    var mediaRatio: Double
//    var userProfileImageUrl: String
//    var userHasSocialMediaNames: Bool
//    var userName: String
//    var categoryName: String
//
//
//    //MARK: - Bindables
//    //from UI
//    var didExpand: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//    var tappedEllipsis: PublishRelay<Void> = PublishRelay<Void>()
//    var doubleTapped: PublishSubject<Void> = PublishSubject<Void>()
//    var likeBlurViewTapped: PublishSubject<Void> = PublishSubject<Void>()
//
//    //to UI
//    var showLikeView: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
//    var isDeactivated: BehaviorRelay<Bool>
//
//    //from Parent
//    var didDisappear: PublishRelay<Void> = PublishRelay()
//    var willBeDisplayed: PublishRelay<Void> = PublishRelay()
//
//    //to Parent
//    var deleteMe: PublishRelay<String> = PublishRelay<String>()
//    var updateDeactivation: PublishRelay<Int> = PublishRelay<Int>()
//
//    //MARK: - Setup
//    init(post: PostModel, index: Int) {
//        self.post = post
//        self.index = index
//        self.postId = post.getId()
//        self.rate = post.getRate()
//        self.description = post.getDescription()
//        self.title = post.getTitle()
//        self.mediaRatio = post.getMediaRatio()
//        self.isDeactivated = BehaviorRelay(value: post.getIsDeactivated())
//        self.userProfileImageUrl = post.getUser().imageUrl.value?.toStringValue() ?? ""
//        self.userHasSocialMediaNames = post.getUser().addedSocialMediaName
//        self.userName = post.getUser().userName.value?.toStringValue() ?? ""
//        self.categoryName = post.getCategory().title.value?.toStringValue() ?? ""
//
//        socialMediaDisplayer.user.accept(post.getUser())
//        setupBindablesFromOwnProperties()
//    }
//
//    //MARK: - Getters
//    func getActions() -> [AlertAction] {
//
//        let deleteWarning = ActionWarning(title: "Warning", message: "Do you really want to delete the post?")
//        let deleteAction = AlertAction(title: "Delete", actionWarning: deleteWarning) { [weak self] () in
//            guard let postId = self?.postId else { return }
//            self?.deleteMe.accept(postId)
//        }
//
//        let likeViewAction = AlertAction(title: showLikeView.value ? "Dismiss Score" : "Show Score") { [weak self] () in
//            guard let showsLikeViewValue = self?.showLikeView.value else { return }
//            self?.showLikeView.accept(!showsLikeViewValue)
//        }
//        return [likeViewAction, deleteAction]
//    }
//
//    //MARK: - Reactive
//    let disposeBag = DisposeBag()
//
//    private func setupBindablesFromOwnProperties() {
//
//        tappedEllipsis.share().asObservable().map { [weak self] (_) -> ActionSheet? in
//            guard let actions = self?.getActions() else { return nil }
//            let actionSheet = ActionSheet(actionHeader: nil, actionMessage: "choose Options", actions: actions)
//            return actionSheet
//            }
//            .flatMap { Observable.from(optional: $0) }
//            .bind(to: showActionSheet).disposed(by: disposeBag)
//
//        Observable.merge([doubleTapped, likeBlurViewTapped]).withLatestFrom(showLikeView).map { (showLikeView) -> Bool in
//            return !showLikeView
//        }.bind(to: showLikeView).disposed(by: disposeBag)
//
//        didDisappear.map { (_) -> Bool in
//            return false
//        }.bind(to: showLikeView).disposed(by: disposeBag)
//
//        //Checks if the associated model already captures the deactivation state of the PostDisplayer correctly
//        isDeactivated.filter { [weak self] (isDeactivated) -> Bool in
//            return isDeactivated != self?.post.getIsDeactivated()
//        }.do(onNext: { [weak self] (isDeactivated) in
//            self?.post.isDeactivated.setValue(of: isDeactivated)
//        }).map { [weak self] (isDeactivated) -> Int in
//            self?.post.isDeactivated.setValue(of: isDeactivated)
//            return self?.index ?? 0
//        }.bind(to: updateDeactivation).disposed(by: disposeBag)
//
//    }
//
//}
