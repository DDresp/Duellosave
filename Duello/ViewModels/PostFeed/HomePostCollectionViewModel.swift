//
//  HomeCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa



class HomePostCollectionViewModel: PostCollectionDisplayer {
    
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? = UserHeaderViewModel()
    var postListDisplayer: PostListDisplayer = HomePostListViewModel()
    
    //MARK: - Child ViewModels
    var userHeaderViewModel: UserHeaderViewModel {
        return userHeaderDisplayer as! UserHeaderViewModel
    }
    
    var postListViewModel: HomePostListViewModel {
        return postListDisplayer as! HomePostListViewModel
    }
    
    //MARK: - Variables
    var totalNumberOfPosts: Int?
    var deletedPost = false //firebase cloud functions arent' fast enough to update the post count
    
    var userPosts: [UserPost] {
        guard let user = user.value, let posts = posts.value else { return [UserPost]() }
        return posts.map { (post) -> UserPost in
            return UserPost(user: user, post: post)
        }
    }

    var lastFetchedPost: PostModel?
    var isFetchingNextPosts: Bool = false
    var restarted = true
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    //Networking
    var startFetching: PublishRelay<Void> = PublishRelay()
    var fetchNext: PublishRelay<Void> = PublishRelay()
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    var updatePost: PublishRelay<Int> = PublishRelay<Int>()
    
    var restart: PublishRelay<Void> = PublishRelay<Void>()
    var refreshChanged: PublishSubject<Void> = PublishSubject()
    var finishedStart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBasicBindables()
        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesToChildViewModels() {
        
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.userHeaderDisplayer?.user.accept(user)
        }).disposed(by: disposeBag)
        
        posts.subscribe(onNext: { [weak self] (posts) in
            guard let _ = posts else { return }
            guard let userPosts = self?.userPosts else { return }
            
            if self?.restarted == true, let postsCount = self?.totalNumberOfPosts {
                self?.postListDisplayer.update(with: userPosts, totalPostsCount: postsCount, fromStart: true)
                self?.restarted = false
            } else {
                self?.postListDisplayer.update(with: userPosts, totalPostsCount: self?.totalNumberOfPosts, fromStart: false)
            }
            
        }).disposed(by: disposeBag)

        Observable.combineLatest(finishedStart, isAppeared).filter { (started, appeared) -> Bool in
            return started && appeared
        }.map { (_, _) -> Void in
            return ()
            }.bind(to: userHeaderViewModel.animateScore).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromChildViewModels() {
        
        userHeaderViewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
        userHeaderViewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)

        postListViewModel.deletePost.bind(to: deletePost).disposed(by: disposeBag)
        postListViewModel.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        postListViewModel.requestNextPosts.bind(to: fetchNext).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromOwnProperties() {
        restart.bind(to: startFetching).disposed(by: disposeBag)
    }
    
}