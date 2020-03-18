//
//  HomeCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa


class HomeCollectionViewModel: PostCollectionDisplayer {
    
    
    typealias UserPost = (UserModel, PostModel)
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - ChildViewModels
    var userHeaderDisplayer: UserHeaderDisplayer? = UserHeaderViewModel()
    var postListDisplayer: PostListDisplayer = PostListViewModel()
    
    //MARK: - Variables
    var numberOfPosts: Int?
    var deletedPost = false //firebase cloud functions arent' fast enough to update the post count
    
    var userPosts: [UserPost] {
        guard let user = user.value, let posts = posts.value else { return [UserPost]() }
        return posts.map { (post) -> UserPost in
            return (user, post)
        }
    }
    
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
    }
    
    private func setupBindablesToChildViewModels() {
        
        user.subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.userHeaderDisplayer?.user.accept(user)
        }).disposed(by: disposeBag)
        
        posts.subscribe(onNext: { [weak self] (posts) in
            guard let _ = posts else { return }
            guard let userPosts = self?.userPosts else { return }
            
            if self?.restarted == true, let postsCount = self?.numberOfPosts {
                self?.postListDisplayer.update(with: userPosts, totalPostsCount: postsCount, fromStart: true)
                self?.restarted = false
            } else {
                self?.postListDisplayer.update(with: userPosts, totalPostsCount: self?.numberOfPosts, fromStart: false)
            }
            
        }).disposed(by: disposeBag)
        
        isAppeared.bind(to: postListDisplayer.isAppeared).disposed(by: disposeBag)

        guard let userHeader = userHeaderDisplayer else { return }

        Observable.combineLatest(postListDisplayer.finishedStart, isAppeared).filter { (started, appeared) -> Bool in
            return started && appeared
        }.map { (_, _) -> Void in
            return ()
            }.bind(to: userHeader.animateScore).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromChildViewModels() {
        
        userHeaderDisplayer?.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
        userHeaderDisplayer?.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)

        postListDisplayer.deletePost.bind(to: deletePost).disposed(by: disposeBag)
        postListDisplayer.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        postListDisplayer.restart.bind(to: startFetching).disposed(by: disposeBag)
        postListDisplayer.requestNextPosts.bind(to: fetchNext).disposed(by: disposeBag)
        
    }
    
}
