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
    var allowsReviewRequest: Bool = false
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
    var isVerified: Bool
    var isBlocked: Bool
    
    let options: PostViewModelOptions
    
    //MARK: - Bindables
    //from UI
    var didExpand: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var tappedEllipsis: PublishRelay<Void> = PublishRelay()
    var tappedReport: PublishRelay<Void> = PublishRelay()
    var doubleTapped: PublishSubject<Void> = PublishSubject()
    var likeBlurViewTapped: PublishSubject<Void> = PublishSubject()
    
    //to UI
    var showLikeView: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay()
    var showAlert: PublishRelay<Alert> = PublishRelay()
    var isDeactivated: BehaviorRelay<Bool>
    var reportStatus: BehaviorRelay<ReportStatusType>
    
    //from Parent
    var didDisappear: PublishRelay<Void> = PublishRelay()
    var willBeDisplayed: PublishRelay<Void> = PublishRelay()
    
    //to Parent
//    var updateDeactivation: PublishRelay<Int> = PublishRelay()
    var changeActivationStatusForMe: PublishRelay<(Bool, String)> = PublishRelay()
    var deleteMe: PublishRelay<String> = PublishRelay()
    var reportMe: PublishRelay<(ReportStatusType, String)> = PublishRelay()
    var reviewMe: PublishRelay<String> = PublishRelay()
    
    
    //MARK: - Setup
    init(post: PostModel, index: Int, options: PostViewModelOptions) {
        self.post = post
        self.index = index
        self.postId = post.getId()
        self.rate = post.getRate()
        self.description = post.getDescription()
        self.title = post.getTitle()
        self.mediaRatio = post.getMediaRatio()
        self.isVerified = post.getIsVerified()
        self.isBlocked = post.getIsBlocked()
        self.isDeactivated = BehaviorRelay(value: post.getIsDeactivated())
        self.reportStatus = BehaviorRelay(value: post.getReportStatus())
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
        
        if reportStatus.value == .noReport, isDeactivated.value == false {
            let likeViewAction = AlertAction(title: showLikeView.value ? "Dismiss Score" : "Show Score") { [weak self] () in
                guard let showsLikeViewValue = self?.showLikeView.value else { return }
                self?.showLikeView.accept(!showsLikeViewValue)
            }
            actions.append(likeViewAction)
        }
        
        if options.allowsDelete {
            let deleteWarning = ActionWarning(title: "Warning", message: "Do you really want to delete the post?")
            let deleteAction = AlertAction(title: "Delete", actionWarning: deleteWarning) { [weak self] () in
                guard let postId = self?.postId else { return }
                self?.deleteMe.accept(postId)
            }
            actions.append(deleteAction)
        }
        
        if options.allowsReport, reportStatus.value == .noReport, !isVerified {
            let reportAction = AlertAction(title: "Report") { [weak self] () in
                self?.tappedReport.accept(())
            }
            actions.append(reportAction)
        }
        
        if options.allowsReviewRequest, reportStatus.value != .noReport, reportStatus.value != .deletedButReviewed, !isBlocked {
            let reviewWarning = ActionWarning(title: "Warning", message: "Please be sure that the stated report isn't justified. Posting inappropriate content can lead to the deactivation of your account.")
            let reviewRequestAction = AlertAction(title: "Request Report Review", actionWarning: reviewWarning) { [weak self] () in
                guard let postId = self?.postId else { return }
                self?.reportStatus.accept(.deletedButReviewed)
                self?.reviewMe.accept(postId)
                
            }
            actions.append(reviewRequestAction)
        }
        
        return actions
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        tappedEllipsis.map { [weak self] (_) -> ActionSheet? in
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
            return isDeactivated != self?.post.getIsDeactivated() && self?.postId != nil
        }.map { [weak self] (isDeactivated) -> (Bool, String) in
            let postId = self?.postId ?? ""
            return (!isDeactivated, postId)
            }.bind(to: changeActivationStatusForMe).disposed(by: disposeBag)
        
        tappedReport.subscribe(onNext: { [weak self] (_) in
            var actions = [AlertAction]()
            let thankYouAlert = Alert(alertMessage: "Thank you for your report!", alertHeader: "Reported")
            
            let inappropriatePostReport = AlertAction(title: "Inappropriate Post") {
                guard let postId = self?.postId else { return }
                self?.reportMe.accept((ReportStatusType.inappropriate, postId))
                self?.showAlert.accept(thankYouAlert)
            }
            let fakeUserReport = AlertAction(title: "Fake User") {
                guard let postId = self?.postId else { return }
                self?.reportMe.accept((ReportStatusType.fakeUser, postId))
                self?.showAlert.accept(thankYouAlert)
            }
            let wrongCategoryReport = AlertAction(title: "Wrong Category") {
                guard let postId = self?.postId else { return }
                self?.reportMe.accept((ReportStatusType.wrongCategory, postId))
                self?.showAlert.accept(thankYouAlert)
            }
            
            actions.append(contentsOf: [inappropriatePostReport, fakeUserReport, wrongCategoryReport])
            
            let actionSheet = ActionSheet(actionHeader: "report", actionMessage: nil, actions: actions)
            self?.showActionSheet.accept(actionSheet)
            
        }).disposed(by: disposeBag)
        
    }
    
}
