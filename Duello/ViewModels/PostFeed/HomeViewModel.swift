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
    
    //MARK: - Models
    var user: UserModel?
    var posts = [PostModel]()
    var displayedPosts = [PostModel]()
    
    let fetchSteps: Int = 6
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer = HomePostCollectionViewModel()
    
    //MARK: - Child ViewModels
    var homeCollectionViewModel: HomePostCollectionViewModel {
        return postCollectionDisplayer as! HomePostCollectionViewModel
    }
    
    //MARK: - Bindables
    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var isFetchingNextPosts: Bool = false //Developing
    

    var displayingAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    
    
    //MARK: - Methods
    
    func start() {
        self.fetchAllPosts()
    }
    
    
    func retrieveNextPosts() {
        if displayedPosts.count < posts.count {
            setNextPosts()
        } else {
            fetchNextPosts()
        }
    }
    
    func setNextPosts() {
        let difference = posts.count - displayedPosts.count
        if difference <= fetchSteps {
            self.displayedPosts = self.posts
            self.displayingAllPosts.accept(true)
            homeCollectionViewModel.posts.accept(self.displayedPosts)
        } else {
            self.displayedPosts = Array(self.posts[..<(displayedPosts.count + fetchSteps)])
            self.displayingAllPosts.accept(false)
            homeCollectionViewModel.posts.accept(self.displayedPosts)
        }
    }
    
    //MARK: - Networking
    
    func fetchAllPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        homeCollectionViewModel.restarted = true
        
        FetchingService.shared.fetchUser(for: uid)
            .flatMapLatest { [weak self] (user) -> Observable<([PostModel], Double)> in
                self?.user = user
                return FetchingService.shared.fetchAllUserPosts(for: uid)
        }.subscribe(onNext: { [weak self] (posts, score) in
            guard let self = self else { return }
            self.user?.score = score
            self.homeCollectionViewModel.user.accept(self.user)
            
            if posts.count <= self.fetchSteps {
                self.displayingAllPosts.accept(true)
                self.posts = posts
                self.displayedPosts = posts
            } else {
                self.displayingAllPosts.accept(false)
                self.posts = posts
                self.displayedPosts = Array(posts[0..<self.fetchSteps])
            }
            
            self.loadedAllPosts.accept(true)
            self.homeCollectionViewModel.posts.accept(self.displayedPosts)
            
        }).disposed(by: disposeBag)
    }
    
    func fetchNextPosts() {

        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = displayedPosts.last?.id, !isFetchingNextPosts, !loadedAllPosts.value else { return }
        
        isFetchingNextPosts = true
        
        DispatchQueue.global(qos: .background).async  {
            FetchingService.shared.fetchUserPosts(for: uid, limit: self.fetchSteps, startId: lastPostId).subscribe(onNext: { [weak self] (posts) in

                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
                self?.loadedAllPosts.accept(reachedEnd)
                self?.displayingAllPosts.accept(true)
                
                self?.posts.append(contentsOf: posts)
                self?.displayedPosts.append(contentsOf: posts)
                self?.homeCollectionViewModel.posts.accept(self?.displayedPosts)
                self?.isFetchingNextPosts = false
                
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func deletePost(for id: String) {
        showLoading.accept(true)
        
        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.showLoading.accept(false)
                self.homeCollectionViewModel.restart.accept(())
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
        setupBindablesFromViewModel()
        setupBindablesToViewModel()
        setupBindablesToCoordinator()
        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesFromViewModel() {
        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToViewModel() {
        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromOwnProperties() {
        
        Observable.combineLatest(displayingAllPosts, loadedAllPosts).map { (displayingAll, loadedAll) -> Bool in
            return displayingAll && loadedAll
            }.bind(to: homeCollectionViewModel.finished).disposed(by: disposeBag)
        
        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
            self?.deletePost(for: postId)
        }).disposed(by: disposeBag)
        
        homeCollectionViewModel.updatePost.subscribe(onNext: { [weak self] (index) in
            self?.updatePost(at: index)
        }).disposed(by: disposeBag)
        
        homeCollectionViewModel.startFetching.subscribe(onNext: { [weak self] (_) in
            self?.start()
            }).disposed(by: disposeBag)
        
        homeCollectionViewModel.fetchNext.subscribe(onNext: { [weak self] (_) in
            self?.retrieveNextPosts()
            }).disposed(by: disposeBag)
        
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
//class HomeViewModel: FeedMasterDisplayer {
//
//    //MARK: - Coordinator
//    weak var coordinator: HomeCoordinatorType? {
//        didSet {
//            setupBindablesToCoordinator()
//        }
//    }
//
//    //MARK: - Models
//    var user: UserModel?
//    var posts = [PostModel]()
//
//    //MARK: - Child Displayers
//    var postCollectionDisplayer: PostCollectionDisplayer = HomePostCollectionViewModel()
//
//    //MARK: - Child ViewModels
//    var homeCollectionViewModel: HomePostCollectionViewModel {
//        return postCollectionDisplayer as! HomePostCollectionViewModel
//    }
//
//    //MARK: - Bindables
//    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
//    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
//
//    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
//    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
//    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
//    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
//    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//
//    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//
//    var willDisplayAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//
//
//    var isFetchingNextPosts: Bool = false //Developing
//
//
//    //MARK: - Setup
//    init() {
//        setupBindables()
//    }
//
//    //MARK: - Networking
//    let fetchSteps: Int = 6
//    var paginationEnded = false //Developing
//
//    func fetchAllPosts() {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        homeCollectionViewModel.restarted = true
//
//        FetchingService.shared.fetchUser(for: uid)
//            .flatMapLatest { [weak self] (user) -> Observable<([PostModel], Double)> in
//                self?.user = user
//                return FetchingService.shared.fetchAllPosts(for: uid)
//        }.subscribe(onNext: { [weak self] (posts, score) in
//            guard let self = self else { return }
//            self.user?.score = score
//            self.homeCollectionViewModel.user.accept(self.user)
//
//            if posts.count <= self.fetchSteps {
//                self.willDisplayAllPosts.accept(true)
//                self.homeCollectionViewModel.posts.accept(posts)
//            } else {
//                self.willDisplayAllPosts.accept(false)
//                self.homeCollectionViewModel.posts.accept(Array(posts[0..<self.fetchSteps]))
//            }
//
//        }).disposed(by: disposeBag)
//
//
////        .subscribe(onNext: { [weak self] (posts, score) in {
////            guard let self = self else { return }
////
////            self.user?.score = score
////            self.homeCollectionViewModel.user.accept(self.user)
////
////            if posts.count < self.fetchSteps {
////                self.willDisplayAllPosts.accept(true)
////                self.homeCollectionViewModel.posts.accept(Array(posts[0..<self.fetchSteps]))
////
////            }  else {
////                self.willDisplayAllPosts.accept(false)
////            }
////
////
////            }
////
//////            self?.paginationEnded = true
//////            self?.loadedAll.accept(true)
//////            self?.postCollectionDisplayer.loadedAll = self?.paginationEnded ?? false //Developing
////
////        }).disposed(by: disposeBag)
//    }
//
//
////        FetchingService.shared.fetchUser(for: uid)
////            .flatMapLatest { [weak self] (user) -> Observable<(RawUserPostsFootprint, [PostModel])> in
////                guard let self = self else { return Observable.empty() }
////                self.homeCollectionViewModel.user.accept(user)
////                let userFootPrint = FetchingService.shared.fetchUserFootprint(for: uid)
////                let posts = FetchingService.shared.fetchPosts(for: uid, at: nil, limit: self.fetchLimit)
////                return Observable.zip(userFootPrint, posts) }
////            .subscribe(onNext: { [weak self] (userFootPrint, posts) in
////
////            //developing
////                self?.paginationEnded = posts.count < (self?.fetchLimit ?? 0)
////                self?.postCollectionDisplayer.finished = self?.paginationEnded ?? false //Developing
////                print("debug: posts count = \(posts.count)")
////
////                var user = self?.homeCollectionViewModel.user.value
////                user?.score = userFootPrint.score
////                self?.homeCollectionViewModel.user.accept(user)
////                self?.homeCollectionViewModel.posts.accept(posts)
////
////            }).disposed(by: self.disposeBag)
////    }
//
//    func getNextPosts() {
//
//        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = homeCollectionViewModel.posts.value?.last?.id, !isFetchingNextPosts, !paginationEnded else { return }
//
//        isFetchingNextPosts = true
//
//        DispatchQueue.global(qos: .background).async  {
//            FetchingService.shared.fetchPosts(for: uid, at: lastPostId, limit: self.fetchSteps).subscribe(onNext: { [weak self] (newPosts) in
//
//                self?.paginationEnded = newPosts.count < (self?.fetchSteps ?? 0)
//                self?.postCollectionDisplayer.loadedAll = self?.paginationEnded ?? false //Developing
//
//                var posts = self?.homeCollectionViewModel.posts.value
//                posts?.append(contentsOf: newPosts)
//                self?.homeCollectionViewModel.posts.accept(posts)
//
//                self?.isFetchingNextPosts = false
//
//            }).disposed(by: self.disposeBag)
//        }
//
//    }
//
//    private func deletePost(for id: String) {
//        showLoading.accept(true)
//
//        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let self = self else { return }
//                self.showLoading.accept(false)
//                self.homeCollectionViewModel.restart.accept(())
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
//        guard let posts = homeCollectionViewModel.posts.value else { return }
//        let post = posts[index]
//        UploadingService.shared.savePost(post: post, postId: post.getId()).subscribe(onNext: { (_) in
//            //Updated Post
//            }).disposed(by: disposeBag)
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
//        setupBindablesFromOwnProperties()
//    }
//
//    private func setupBindablesFromViewModel() {
//        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
//        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
//        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToViewModel() {
//        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
//    }
//
//    private func setupBindablesFromOwnProperties() {
//
//        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
//            self?.deletePost(for: postId)
//        }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.updatePost.subscribe(onNext: { [weak self] (index) in
//            self?.updatePost(at: index)
//        }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.startFetching.subscribe(onNext: { [weak self] (_) in
//            self?.fetchAllPosts()
//            }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.fetchNext.subscribe(onNext: { [weak self] (_) in
//            self?.getNextPosts()
//            }).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToCoordinator() {
//
//        guard let coordinator = coordinator else { return }
//
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
//
//    }
//
//}




//-----------------------------------------------



//class HomeViewModel: FeedMasterDisplayer {
//
//    //MARK: - Coordinator
//    weak var coordinator: HomeCoordinatorType? {
//        didSet {
//            setupBindablesToCoordinator()
//        }
//    }
//
//    //MARK: - Child Displayers
//    var postCollectionDisplayer: PostCollectionDisplayer = HomePostCollectionViewModel()
//
//    //MARK: - Child ViewModels
//    var homeCollectionViewModel: HomePostCollectionViewModel {
//        return postCollectionDisplayer as! HomePostCollectionViewModel
//    }
//
//    //MARK: - Bindables
//    var settingsTapped: PublishSubject<Void> = PublishSubject<Void>()
//    var logoutTapped: PublishSubject<Void> = PublishSubject<Void>()
//
//    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
//    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
//    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
//    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
//    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
//
//    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
//    var isFetchingNextPosts: Bool = false //Developing
//
//    //MARK: - Setup
//    init() {
//        setupBindables()
//    }
//
//    //MARK: - Networking
//    func startFetching() {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        homeCollectionViewModel.restarted = true
//
//        FetchingService.shared.fetchUser(for: uid)
//            .flatMapLatest { [weak self] (user) -> Observable<(RawUserPostsFootprint, [PostModel])> in
//                self?.homeCollectionViewModel.user.accept(user)
//                let userFootPrint = FetchingService.shared.fetchUserFootprint(for: uid)
//                let posts = FetchingService.shared.fetchPosts(for: uid, at: nil, limit: 10)
//                return Observable.zip(userFootPrint, posts) }
//            .subscribe(onNext: { [weak self] (userFootPrint, posts) in
//                if self?.homeCollectionViewModel.deletedPost == true {
//                    guard let currentNumberOfPosts = self?.homeCollectionViewModel.totalNumberOfPosts else { return }
//                    self?.homeCollectionViewModel.totalNumberOfPosts = currentNumberOfPosts - 1
//                    self?.homeCollectionViewModel.deletedPost = false
//                } else {
//                    self?.homeCollectionViewModel.totalNumberOfPosts = userFootPrint.numberOfPosts
//                }
//                var user = self?.homeCollectionViewModel.user.value
//                user?.score = userFootPrint.score
//                self?.homeCollectionViewModel.user.accept(user)
//                self?.homeCollectionViewModel.posts.accept(posts)
//            }).disposed(by: self.disposeBag)
//    }
//
//
//    func fetchNextPosts() {
//        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = homeCollectionViewModel.posts.value?.last?.id, !isFetchingNextPosts else { return }
//        //        guard let uid = Auth.auth().currentUser?.uid, let lastPostId = homeCollectionViewModel.posts.value?.last?.id, !homeCollectionViewModel.isFetchingNextPosts else { return }
//        //        homeCollectionViewModel.isFetchingNextPosts = true
//        isFetchingNextPosts = true
//        DispatchQueue.global(qos: .background).async  {
//            FetchingService.shared.fetchPosts(for: uid, at: lastPostId, limit: 6).subscribe(onNext: { [weak self] (newPosts) in
//                var posts = self?.homeCollectionViewModel.posts.value
//                posts?.append(contentsOf: newPosts)
//                self?.homeCollectionViewModel.posts.accept(posts)
//                //                self?.homeCollectionViewModel.isFetchingNextPosts = false
//                self?.isFetchingNextPosts = false
//
//            }).disposed(by: self.disposeBag)
//        }
//
//    }
//
//    private func deletePost(for id: String) {
//        showLoading.accept(true)
//
//        DeletingService.shared.deletePost(for: id).asObservable().timeout(10, other: Observable.error(RxError.timeout), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (_) in
//                guard let self = self else { return }
//                self.showLoading.accept(false)
//                self.homeCollectionViewModel.deletedPost = true
//                self.homeCollectionViewModel.restart.accept(())
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
//        guard let posts = homeCollectionViewModel.posts.value else { return }
//        let post = posts[index]
//        UploadingService.shared.savePost(post: post, postId: post.getId()).subscribe(onNext: { (_) in
//            //Updated Post
//            }).disposed(by: disposeBag)
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
//        setupBindablesFromOwnProperties()
//    }
//
//    private func setupBindablesFromViewModel() {
//        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
//        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
//        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToViewModel() {
//        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
//    }
//
//    private func setupBindablesFromOwnProperties() {
//
//        homeCollectionViewModel.deletePost.subscribe(onNext: { [weak self] (postId) in
//            self?.deletePost(for: postId)
//        }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.updatePost.subscribe(onNext: { [weak self] (index) in
//            self?.updatePost(at: index)
//        }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.startFetching.subscribe(onNext: { [weak self] (_) in
//            self?.startFetching()
//            }).disposed(by: disposeBag)
//
//        homeCollectionViewModel.fetchNext.subscribe(onNext: { [weak self] (_) in
//            self?.fetchNextPosts()
//            }).disposed(by: disposeBag)
//
//    }
//
//    private func setupBindablesToCoordinator() {
//
//        guard let coordinator = coordinator else { return }
//
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
//
//    }
//
//}
