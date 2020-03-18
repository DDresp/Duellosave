//
//  HomeViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class HomeViewModel: FeedDisplayer {
    
    typealias UserPost = (UserModel, PostModel)
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - Coordinator
    weak var coordinator: HomeCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
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
    var lastFetchedPost: PostModel?
    var isFetchingNextPosts: Bool = false
    
    //MARK: - Bindables

    //HomeViewModel Specific
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    var updatePost: PublishRelay<Int> = PublishRelay<Int>()
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    //
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Networking
    func startFetching() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        restarted = true
        
        FetchingService.shared.fetchUser(for: uid)
            .flatMapLatest { [weak self] (user) -> Observable<(RawUserPostsFootprint, [PostModel])> in
                self?.user.accept(user)
                let userFootPrint = FetchingService.shared.fetchUserPostsFootprint(for: uid)
                let userPosts = FetchingService.shared.fetchUserPosts(for: uid, at: nil, limit: 10)
                return Observable.zip(userFootPrint, userPosts) }
            .subscribe(onNext: { [weak self] (userFootPrint, posts) in
                if self?.deletedPost == true {
                    guard let currentNumberOfPosts = self?.numberOfPosts else { return }
                    self?.numberOfPosts = currentNumberOfPosts - 1
                    self?.deletedPost = false
                } else {
                    self?.numberOfPosts = userFootPrint.numberOfPosts
                }
                var user = self?.user.value
                user?.score = userFootPrint.score
                self?.user.accept(user)
                self?.posts.accept(posts)
                }).disposed(by: self.disposeBag)
    }
    
    func fetchNextPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = posts.value?.last?.id, !isFetchingNextPosts else { return }
        isFetchingNextPosts = true
        FetchingService.shared.fetchUserPosts(for: uid, at: lastPostId, limit: 10).asObservable().subscribe(onNext: { [weak self] (newPosts) in
            
            self?.isFetchingNextPosts = false
            var posts = self?.posts.value
            posts?.append(contentsOf: newPosts)
            self?.posts.accept(posts)
        }).disposed(by: self.disposeBag)
        
    }
    
    private func deletePost(for id: String) {
        showLoading.accept(true)
        
        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.showLoading.accept(false)
                self.deletedPost = true
                self.postListDisplayer.restart.accept(())
                }, onError: { [weak self] (err) in
                    switch err {
                    case RxError.timeout: self?.showAlert.accept(Alert(alertMessage: "The Post will be deleted as soon as the internet connection works properly again.", alertHeader: "Network Error"))
                    default:
                        guard let error = err as? DeletingError else {
                            return }
                        self?.showAlert.accept(Alert(alertMessage: error.errorMessage, alertHeader: error.errorHeader))
                    }
                    self?.showLoading.accept(false)
            }).disposed(by: disposeBag)
    }
    
    private func updatePost(at index: Int) {
        guard let posts = posts.value else { return }
        let post = posts[index]
        UploadingService.shared.savePost(post: post, postId: post.getId()).subscribe(onNext: { (_) in
            //Updated Post
            }).disposed(by: disposeBag)

    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBasicBindables()
        setupBindablesToCoordinator()
        setupBindablesFromOwnProperties()
        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
    }
    
    private func setupBindablesFromOwnProperties() {
        
        deletePost.subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)
        
        updatePost.subscribe(onNext: { [weak self] (index) in
            self?.updatePost(at: index)
        }).disposed(by: disposeBag)
        
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
        
        viewIsAppeared.bind(to: postListDisplayer.isAppeared).disposed(by: disposeBag)

        guard let userHeader = userHeaderDisplayer else { return }

        Observable.combineLatest(postListDisplayer.finishedStart, viewIsAppeared).filter { (started, appeared) -> Bool in
            return started && appeared
        }.map { (_, _) -> Void in
            return ()
            }.bind(to: userHeader.animateScore).disposed(by: disposeBag)

    }
    
    private func setupBindablesToCoordinator() {
        
        guard let coordinator = coordinator else { return }
        
        logoutTapped.asObservable().do(onNext: { (_) in
            do {
                try Auth.auth().signOut()
            } catch let err {
                print("failed to logout the user", err)
            }
        }).bind(to: coordinator.loggedOut).disposed(by: disposeBag)
        
        settingsTapped.asObservable().bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
        userHeaderDisplayer?.imageTapped.asObservable().bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromChildViewModels() {
        
        userHeaderDisplayer?.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
        userHeaderDisplayer?.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)

        postListDisplayer.deletePost.bind(to: deletePost).disposed(by: disposeBag)
        postListDisplayer.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        
    }
    
}
