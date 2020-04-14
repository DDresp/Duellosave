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

class HomeViewModel: SimplePostCollectionMasterViewModel {

    //MARK: - Coordinator
    weak var coordinator: HomeCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Child ViewModels
    var homeCollectionViewModel: UserPostCollectionViewModel {
        return postCollectionDisplayer as! UserPostCollectionViewModel
    }
    
    //MARK: - Variables
    var lastFetchAll: Date? //important to fetch all for getting the correct score
    let fetchingAllPause: Double = 10 //user shouldn't be able to fetch all Posts so often (too expensive)
    var forceFetchingAll = false
    
    //MARK: - Bindables
    var user: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
    
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    //MARK: - Setup
    init() {
        super.init(postCollectionDisplayer: UserPostCollectionViewModel(), fetchSteps: 6) { (limit, startId) -> Observable<[PostModel]> in
            let uid = Auth.auth().currentUser?.uid ?? ""
            return FetchingService.shared.fetchUserPosts(for: uid, limit: limit, startId: startId)
        }
    }
    
    //MARK: - Methods
    override func start() {
        if let lastFetchTime = lastFetchAll, Date().timeIntervalSince(lastFetchTime) < fetchingAllPause && !forceFetchingAll {
            fetchLimitedPosts()
        } else {
            forceFetchingAll = false
            fetchAll()
        }
    }
    
    override func retrieveNextPosts() {
        if displayingAllFetchedPosts.value == false {
            getNextPosts()
        } else {
            fetchLimitedPosts()
        }
    }
    
    func getNextPosts() {
        guard let displayedPosts = displayedPosts.value else { return }
        
        let difference = posts.count - displayedPosts.count
        if difference <= fetchSteps {
            self.displayedPosts.accept(posts)
        } else {
            let displayedPosts = Array(posts[..<(displayedPosts.count + fetchSteps)])
            self.displayedPosts.accept(displayedPosts)
        }
        
    }
    
    //MARK: - Networking
    //quite different because of the fetching logic
    func fetchAll() {
        
        guard let uid = Auth.auth().currentUser?.uid, !isFetching else { return }
        lastFetchAll = Date()
        
        isFetching = true
        FetchingService.shared.fetchUser(for: uid)
            .flatMapLatest { [weak self] (user) -> Observable<([PostModel], Double)> in
                self?.user.accept(user)
                return FetchingService.shared.fetchAllUserPosts(for: uid)
        }.subscribe(onNext: { [weak self] (posts, score) in
            guard let self = self else { return }
            self.isFetching = false
            self.loadedAllPosts.accept(true)
            var user = self.user.value
            user?.score = score
            self.user.accept(user)
            if posts.count <= self.fetchSteps {
                self.posts = posts
                self.displayedPosts.accept(self.posts)
            } else {
                self.posts = posts
                let displayedPosts = Array(self.posts[0..<self.fetchSteps])
                self.displayedPosts.accept(displayedPosts)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func deletePost(for id: String) {
        showLoading.accept(true)
        
        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.showLoading.accept(false)
                self.forceFetchingAll = true
                self.homeCollectionViewModel.needsRestart.accept(true)
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
    override func setupBindblesFromChildDisplayer() {
        super.setupBindblesFromChildDisplayer()
        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)
    }
    
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        user.bind(to: homeCollectionViewModel.user).disposed(by: disposeBag)
    }
        
    func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        logoutTapped.do(onNext: { (_) in
            do {
                try Auth.auth().signOut()
            } catch let err {
                print("failed to logout the user", err)
            }
        }).bind(to: coordinator.loggedOut).disposed(by: disposeBag)
        
        settingsTapped.map { [weak self] (_) -> UserModel? in
            return self?.user.value
        }.flatMap { (user) -> Observable<UserModel> in
            return Observable.from(optional: user)
            }.bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
        
//        settingsTapped.bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
//        homeCollectionViewModel.postHeaderDisplayer?.imageTapped.asObservable().bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
    }
    
}
