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

class HomeViewModel: FeedMasterDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: HomeCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer = HomePostCollectionViewModel()

    //MARK: - Child ViewModels
    var homeCollectionViewModel: HomePostCollectionViewModel {
        return postCollectionDisplayer as! HomePostCollectionViewModel
    }

    //MARK: - Variables
    var lastFetchedPost: PostModel?
    var isFetchingNextPosts: Bool = false
    
    //MARK: - Bindables
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Networking
    func startFetching() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        homeCollectionViewModel.restarted = true
        
        FetchingService.shared.fetchUser(for: uid)
            .flatMapLatest { [weak self] (user) -> Observable<(RawUserPostsFootprint, [PostModel])> in
                self?.homeCollectionViewModel.user.accept(user)
                let userFootPrint = FetchingService.shared.fetchUserPostsFootprint(for: uid)
                let userPosts = FetchingService.shared.fetchUserPosts(for: uid, at: nil, limit: 10)
                return Observable.zip(userFootPrint, userPosts) }
            .subscribe(onNext: { [weak self] (userFootPrint, posts) in
                if self?.homeCollectionViewModel.deletedPost == true {
                    guard let currentNumberOfPosts = self?.homeCollectionViewModel.totalNumberOfPosts else { return }
                    self?.homeCollectionViewModel.totalNumberOfPosts = currentNumberOfPosts - 1
                    self?.homeCollectionViewModel.deletedPost = false
                } else {
                    self?.homeCollectionViewModel.totalNumberOfPosts = userFootPrint.numberOfPosts
                }
                var user = self?.homeCollectionViewModel.user.value
                user?.score = userFootPrint.score
                self?.homeCollectionViewModel.user.accept(user)
                self?.homeCollectionViewModel.posts.accept(posts)
                }).disposed(by: self.disposeBag)
    }
    
    func fetchNextPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = homeCollectionViewModel.posts.value?.last?.id, !isFetchingNextPosts else { return }
        isFetchingNextPosts = true
        FetchingService.shared.fetchUserPosts(for: uid, at: lastPostId, limit: 10).asObservable().subscribe(onNext: { [weak self] (newPosts) in
            
            self?.isFetchingNextPosts = false
            var posts = self?.homeCollectionViewModel.posts.value
            posts?.append(contentsOf: newPosts)
            self?.homeCollectionViewModel.posts.accept(posts)
        }).disposed(by: self.disposeBag)
        
    }
    
    private func deletePost(for id: String) {
        showLoading.accept(true)
        
        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.showLoading.accept(false)
                self.homeCollectionViewModel.deletedPost = true
                self.homeCollectionViewModel.postListDisplayer.restart.accept(())
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
        guard let posts = homeCollectionViewModel.posts.value else { return }
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
        setupBindablesToChildViewModels()
    }
    
    private func setupBindablesFromOwnProperties() {
        
        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)
        
        homeCollectionViewModel.updatePost.subscribe(onNext: { [weak self] (index) in
            self?.updatePost(at: index)
        }).disposed(by: disposeBag)
        
        homeCollectionViewModel.startFetching.subscribe(onNext: { [weak self] (_) in
            self?.startFetching()
            }).disposed(by: disposeBag)
        
        homeCollectionViewModel.fetchNext.subscribe(onNext: { [weak self] (_) in
            self?.fetchNextPosts()
            }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToChildViewModels() {
    
        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)

    }
    
    private func setupBindablesToCoordinator() {
        
        guard let coordinator = coordinator else { return }
        
        logoutTapped.do(onNext: { (_) in
            do {
                try Auth.auth().signOut()
            } catch let err {
                print("failed to logout the user", err)
            }
        }).bind(to: coordinator.loggedOut).disposed(by: disposeBag)
        
        settingsTapped.bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
        homeCollectionViewModel.userHeaderDisplayer?.imageTapped.asObservable().bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
        
    }
    
}
