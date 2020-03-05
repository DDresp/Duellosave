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
    var postCollectionDisplayer: PostCollectionDisplayer = PostCollectionViewModel()
    
    //MARK: - Variables
    var numberOfPosts: Int?
    var deletedPost = false //firebase cloud functions arent' fast enough to update the post count
    
    var userPosts: [UserPost] {
        guard let user = user.value, let posts = posts.value else { return [UserPost]() }
        return posts.map { (post) -> UserPost in
            return (user, post)
        }
    }
    
    //MARK: - Bindables
    var restart: PublishRelay<Void> = PublishRelay<Void>()
    var reloadData: PublishRelay<Void> = PublishRelay<Void>()
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    
    var refreshChanged: PublishSubject<Void> = PublishSubject<Void>()
    var updateLayout: PublishRelay<Bool> = PublishRelay<Bool>()
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var viewDidDisappear: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init() {
        setupBindables()
        startFetching()
    }
    
    //MARK: - Networking
    var lastFetchedPost: PostModel?
    var isFetchingNextPosts: Bool = false
    var isStarting = false
    
    func startFetching() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.userHeaderDisplayer?.isLoading.accept(true)
        
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
                
                    }, onError: { [weak self] (err) in
                        self?.userHeaderDisplayer?.isLoading.accept(false)
                        self?.isStarting = false
                }).disposed(by: self.disposeBag)
        
    }
    
    private func fetchNextPosts() {
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
                self.restart.accept(())
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
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBindablesToCoordinator()
        setupBindablesFromOwnProperties()
        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
    }
    
    private func setupBindablesFromOwnProperties() {
        
        refreshChanged.bind(to: restart).disposed(by: disposeBag)
        
        restart.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.disposeBag = DisposeBag()
            self?.userHeaderDisplayer = UserHeaderViewModel()
            self?.postCollectionDisplayer = PostCollectionViewModel()
            self?.user.accept(nil)
            self?.posts.accept(nil)
            self?.setupBindables()
            self?.startFetching()
        }).disposed(by: disposeBag)
        
        deletePost.asObservable().subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToChildViewModels() {
        
        user.asObservable().subscribe(onNext: { [weak self] (user) in
            guard let user = user else { return }
            self?.userHeaderDisplayer?.user.accept(user)
            self?.reloadData.accept(())
        }).disposed(by: disposeBag)
        
        posts.asObservable().subscribe(onNext: { [weak self] (posts) in
            guard let _ = posts else { return }
            guard let userPosts = self?.userPosts else { return }
            self?.postCollectionDisplayer.update(with: userPosts, totalPostsCount: self?.numberOfPosts)
            self?.reloadData.accept(())
        }).disposed(by: disposeBag)
        
        viewDidDisappear.asObservable().bind(to: postCollectionDisplayer.viewDidDisappear).disposed(by: disposeBag)
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
        
        userHeaderDisplayer?.socialMediaViewModel.selectedLink.asObservable().bind(to: loadLink).disposed(by: disposeBag)
        userHeaderDisplayer?.socialMediaViewModel.showAdditionalLinkAlert.asObservable().bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        
        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postCollectionDisplayer.needsUpdate.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.fetchNextPosts()
        }).disposed(by: disposeBag)
        postCollectionDisplayer.updateLayout.bind(to: updateLayout).disposed(by: disposeBag)
        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postCollectionDisplayer.deleteItem.bind(to: deletePost).disposed(by: disposeBag)
    }
    
}
