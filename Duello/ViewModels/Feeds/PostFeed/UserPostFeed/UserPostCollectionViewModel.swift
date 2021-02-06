//
//  HomeCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import RxSwift
import RxCocoa

class UserPostCollectionViewModel: PostCollectionViewModel {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)

    //MARK: - Child ViewModels
    var headerViewModel: UserHeaderViewModel {
        return postHeaderDisplayer as! UserHeaderViewModel
    }
    
    var listViewModel: UserPostListViewModel {
        return postListDisplayer as! UserPostListViewModel
    }
    
    //MARK: - Bindables
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    var requestedReviewPost: PublishRelay<String> = PublishRelay<String>()
    
    //MARK: - Setup
    init() {
        super.init(listDisplayer: UserPostListViewModel(), headerDisplayer: UserHeaderViewModel())
    }

    //MARK: - Reactive
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.headerViewModel.user.accept(user)
        }).disposed(by: disposeBag)

        Observable.combineLatest(uiLoaded, viewIsAppeared).filter { (started, appeared) -> Bool in
            return started && appeared
        }.map { (_, _) -> Void in
            return ()
            }.bind(to: headerViewModel.animateScore).disposed(by: disposeBag)
        
    }
    
    override func setupBindablesFromChildDisplayer() {
        super.setupBindablesFromChildDisplayer()
        headerViewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
        headerViewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        
        listViewModel.deletePost.bind(to: deletePost).disposed(by: disposeBag)
        listViewModel.requestedReviewPost.bind(to: requestedReviewPost).disposed(by: disposeBag)
        
    }
    
}


//import RxSwift
//import RxCocoa
//
//class UserPostCollectionViewModel: PostCollectionDisplayer {
//
//    //MARK: - Models
//    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
//    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
//
//    //MARK: - Child Displayers
//    var headerDisplayer: UserHeaderDisplayer? = UserHeaderViewModel()
//    var postListDisplayer: PostListDisplayer = UserPostListViewModel()
//
//    //MARK: - Child ViewModels
//    var userHeaderViewModel: UserHeaderViewModel {
//        return headerDisplayer as! UserHeaderViewModel
//    }
//
//    var postListViewModel: UserPostListViewModel {
//        return postListDisplayer as! UserPostListViewModel
//    }
//
//    //MARK: - Bindables
//
//    //from Parent
//    var allDataLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//
//    //to Parent
//    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var fetchNext: PublishRelay<Void> = PublishRelay()
//    var updatePost: PublishRelay<Int> = PublishRelay()
//    var deletePost: PublishRelay<String> = PublishRelay<String>()
//
//    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
//    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
//    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
//    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
//    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//
//    //From UI (CollectionView)
//    var refreshChanged: PublishSubject<Void> = PublishSubject()
//    var uiLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
//
//    //To UI
//    var insertData: PublishRelay<(Int, Int)> = PublishRelay()
//    var reloadData: PublishRelay<Void> = PublishRelay()
//    var updateLayout: PublishRelay<Void> = PublishRelay()
//
//    //MARK: - Setup
//    init() {
//        setupBindables()
//    }
//
//    //MARK: - Reactive
//    var disposeBag = DisposeBag()
//
//    private func setupBindables() {
//        setupDisplayerBindables()
//        setupViewModelBindables()
//    }
//
//    private func setupViewModelBindables() {
//        setupBindablesToChildViewModels()
//        setupBindablesFromChildViewModels()
//    }
//
//    private func setupBindablesToChildViewModels() {
//
//        user.subscribe(onNext: { [weak self] (user) in
//            guard let user = user else { return }
//            self?.userHeaderViewModel.user.accept(user)
//        }).disposed(by: disposeBag)
//
//        Observable.combineLatest(uiLoaded, viewIsAppeared).filter { (started, appeared) -> Bool in
//            return started && appeared
//        }.map { (_, _) -> Void in
//            return ()
//            }.bind(to: userHeaderViewModel.animateScore).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesFromChildViewModels() {
//
//        userHeaderViewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
//        userHeaderViewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
//
//        postListViewModel.deletePost.bind(to: deletePost).disposed(by: disposeBag)
//
//    }
//
//}
