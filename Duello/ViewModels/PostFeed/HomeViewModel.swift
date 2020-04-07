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

class HomeViewModel: TestPostCollectionMasterDisplayer {

    //MARK: - Coordinator
    weak var coordinator: HomeCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var posts = [PostModel]()
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer = UserPostCollectionViewModel()
    
    //MARK: - Child ViewModels
    var homeCollectionViewModel: UserPostCollectionViewModel {
        return postCollectionDisplayer as! UserPostCollectionViewModel
    }
    
    //MARK: - Variables
    let fetchSteps: Int = 6
    var lastFetchAll: Date? //important to fetch all for getting the correct score
    let fetchingAllPause: Double = 10 //user shouldn't be able to fetch all Posts so often (too expensive)
    var forceFetchingAll = false
    var isFetching = false
    
    //MARK: - Bindables
     var user: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
     var displayedPosts: BehaviorRelay<[PostModel]?> = BehaviorRelay(value: nil)
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var displayingAllFetchedPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Methods
    func start() {
        reset()
        
        if let lastFetchTime = lastFetchAll, Date().timeIntervalSince(lastFetchTime) < fetchingAllPause && !forceFetchingAll {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            fetchLimitedPosts(for: uid)
        } else {
            forceFetchingAll = false
            fetchAll()
        }
    }
    
    func retrieveNextPosts() {
        if displayingAllFetchedPosts.value == false {
            getNextPosts()
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            fetchLimitedPosts(for: uid)
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
    
    
    //MARK: - Getters
    func getLimitedPostFetch(id: String, limit: Int, startId: String?) -> Observable<[PostModel]> {
        return FetchingService.shared.fetchUserPosts(for: id, limit: limit, startId: startId)
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupChildDisplayerBindables()
        setupBindablesFromViewModel()
        setupBindablesToViewModel()
        setupBindablesToCoordinator()
    }
    
    private func setupBindablesFromViewModel() {
        
        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)

    }
    
    private func setupBindablesToViewModel() {
        
        user.bind(to: homeCollectionViewModel.user).disposed(by: disposeBag)
        
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


//import RxSwift
//import RxCocoa
//import Firebase
//
//class HomeViewModel: PostCollectionMasterDisplayer {
//
//    //MARK: - Coordinator
//    weak var coordinator: HomeCoordinatorType? {
//        didSet {
//            setupBindablesToCoordinator()
//        }
//    }
//
//    //MARK: - Models
//    var posts = [PostModel]()
//
//    //MARK: - Child Displayers
//    var postCollectionDisplayer: PostCollectionDisplayer = UserPostCollectionViewModel()
//
//    //MARK: - Child ViewModels
//    var homeCollectionViewModel: UserPostCollectionViewModel {
//        return postCollectionDisplayer as! UserPostCollectionViewModel
//    }
//
//    //MARK: - Variables
//    let fetchSteps: Int = 6
//    var lastFetchAll: Date? //important to fetch all for getting the correct score
//    let fetchingAllPause: Double = 10 //user shouldn't be able to fetch all Posts so often (too expensive)
//    var forceFetchingAll = false
//    var isFetching = false
//
//    //MARK: - Bindables
//     var user: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
//     var displayedPosts: BehaviorRelay<[PostModel]?> = BehaviorRelay(value: nil)
//
//    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
//    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
//    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
//    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
//    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//
//    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//
//    var displayingAllFetchedPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//
//    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
//    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
//
//    //MARK: - Setup
//    init() {
//        setupBindables()
//    }
//
//    //MARK: - Methods
//
//    //This is custom and has to be conformed
//    func start() {
//
//        posts = [PostModel]()
//        displayedPosts.accept(nil)
//
//        self.loadedAllPosts.accept(false)
//
//        if let lastFetchTime = lastFetchAll, Date().timeIntervalSince(lastFetchTime) < fetchingAllPause && !forceFetchingAll {
//            fetchLimitedPosts()
//        } else {
//            forceFetchingAll = false
//            fetchAll()
//        }
//    }
//
//    //This is custom and has to be conformed
//    func retrieveNextPosts() {
//        if displayingAllFetchedPosts.value == false {
//            getNextPosts()
//        } else {
//            fetchLimitedPosts()
//        }
//    }
//
//    //SAME
//    func getNextPosts() {
//        guard let displayedPosts = displayedPosts.value else { return }
//
//        let difference = posts.count - displayedPosts.count
//        if difference <= fetchSteps {
//            self.displayedPosts.accept(posts)
//        } else {
//            let displayedPosts = Array(posts[..<(displayedPosts.count + fetchSteps)])
//            self.displayedPosts.accept(displayedPosts)
//        }
//
//    }
//
//    //MARK: - Networking
//    //quite different because of the fetching logic
//    func fetchAll() {
//
//        guard let uid = Auth.auth().currentUser?.uid, !isFetching else { return }
//        lastFetchAll = Date()
//
//        isFetching = true
//        FetchingService.shared.fetchUser(for: uid)
//            .flatMapLatest { [weak self] (user) -> Observable<([PostModel], Double)> in
//                self?.user.accept(user)
//                return FetchingService.shared.fetchAllUserPosts(for: uid)
//        }.subscribe(onNext: { [weak self] (posts, score) in
//            guard let self = self else { return }
//            self.isFetching = false
//            self.loadedAllPosts.accept(true)
//            var user = self.user.value
//            user?.score = score
//            self.user.accept(user)
//            if posts.count <= self.fetchSteps {
//                self.posts = posts
//                self.displayedPosts.accept(self.posts)
//            } else {
//                self.posts = posts
//                let displayedPosts = Array(self.posts[0..<self.fetchSteps])
//                self.displayedPosts.accept(displayedPosts)
//            }
//
//        }).disposed(by: disposeBag)
//    }
//
//    func fetchLimitedPosts() {
//
//        guard let uid = Auth.auth().currentUser?.uid, !isFetching, !loadedAllPosts.value else { return }
//
//        let lastPostId = posts.last?.id
//        isFetching = true
//
//        DispatchQueue.global(qos: .background).async  {
//            FetchingService.shared.fetchUserPosts(for: uid, limit: self.fetchSteps, startId: lastPostId).subscribe(onNext: { [weak self] (posts) in
//                self?.isFetching = false
//                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
//                self?.loadedAllPosts.accept(reachedEnd)
//                self?.posts.append(contentsOf: posts)
//                self?.displayedPosts.accept(self?.posts)
//
//            }).disposed(by: self.disposeBag)
//        }
//    }
//
//    private func deletePost(for id: String) {
//        showLoading.accept(true)
//
//        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let self = self else { return }
//                self.showLoading.accept(false)
//                self.forceFetchingAll = true
//                self.homeCollectionViewModel.needsRestart.accept(true)
//                }, onError: { [weak self] (err) in
//                    switch err {
//                    case RxError.timeout: self?.showAlert.accept(Alert(alertMessage: "The Post will be deleted as soon as the internet connection works properly again.", alertHeader: "Network Error"))
//                    default:
//                        guard let error = err as? DeletingError else {
//                            return }
//                        self?.showAlert.accept(Alert(alertMessage: error.errorMessage, alertHeader: error.errorHeader))
//                    }
//                    self?.showLoading.accept(false)
//            }).disposed(by: disposeBag)
//
//    }
//
//    private func updatePost(at index: Int) {
//        guard let posts = postCollectionDisplayer.posts.value else { return }
//        let post = posts[index]
//        UploadingService.shared.updatePost(post: post).subscribe(onNext: { (_) in
//            //Updated Post
//        }).disposed(by: disposeBag)
//
//    }
//
//    //MARK: - Reactive
//    var disposeBag = DisposeBag()
//
//    private func setupBindables() {
//        setupBindablesFromViewModel()
//        setupBindablesToViewModel()
//        setupBindablesToCoordinator()
//    }
//
//    private func setupBindablesFromViewModel() {
//        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
//        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
//        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
//
//        postCollectionDisplayer.needsRestart.filter { (needsRestart) -> Bool in
//            return needsRestart
//        }.subscribe(onNext: { [weak self] (_) in
//            self?.start()
//        }).disposed(by: disposeBag)
//
//        postCollectionDisplayer.fetchNext.subscribe(onNext: { [weak self] (_) in
//            guard (self?.posts.count ?? 0) > 0 else { return }
//            self?.retrieveNextPosts()
//        }).disposed(by: disposeBag)
//
//        postCollectionDisplayer.updatePost.subscribe(onNext: { [weak self] (index) in
//            self?.updatePost(at: index)
//        }).disposed(by: disposeBag)
//        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
//            self?.deletePost(for: postId)
//        }).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToViewModel() {
//        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
//
//        Observable.combineLatest(displayingAllFetchedPosts, loadedAllPosts).map { (displayingAll, loadedAll) -> Bool in
//            return displayingAll && loadedAll
//            }.bind(to: postCollectionDisplayer.finished).disposed(by: disposeBag)
//
//        displayedPosts.map { [weak self] (displayedPosts) -> Bool in
//            guard let self = self else { return false }
//            return self.posts.count == (displayedPosts?.count ?? 0)
//            }.bind(to: displayingAllFetchedPosts).disposed(by: disposeBag)
//
//        displayedPosts.bind(to: postCollectionDisplayer.posts).disposed(by: disposeBag)
//
//        user.bind(to: homeCollectionViewModel.user).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToCoordinator() {
//
//        guard let coordinator = coordinator else { return }
//        logoutTapped.do(onNext: { (_) in
//            do {
//                try Auth.auth().signOut()
//            } catch let err {
//                print("failed to logout the user", err)
//            }
//        }).bind(to: coordinator.loggedOut).disposed(by: disposeBag)
//
//        settingsTapped.bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
//        homeCollectionViewModel.userHeaderDisplayer?.imageTapped.asObservable().bind(to: coordinator.requestedSettings).disposed(by: disposeBag)
//    }
//
//}
