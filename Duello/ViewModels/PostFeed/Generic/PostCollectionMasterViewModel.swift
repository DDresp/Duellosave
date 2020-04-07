//
//  PostCollectionMasterViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

protocol TestPostCollectionMasterDisplayer: class, PostCollectionMasterDisplayer {
    
    //MARK: - Models
    var posts: [PostModel] { get set }
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer { get }
    
    //MARK: - Variables
    var fetchSteps: Int { get }
    var isFetching: Bool { get set }
    
    //MARK: - Bindables
    var displayedPosts: BehaviorRelay<[PostModel]?> { get }
    
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }

    var displayingAllFetchedPosts: BehaviorRelay<Bool> { get }
    var loadedAllPosts: BehaviorRelay<Bool> { get }
    
    //MARK: - Methods
    func start() -> ()
    func retrieveNextPosts() -> ()
    
    //MARK: - Getters
    func getLimitedPostFetch(id: String, limit: Int, startId: String?) -> Observable<[PostModel]>
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }
    
}

//MARK: - DEFAULT FUNCTIONS
extension TestPostCollectionMasterDisplayer {
    
    //MARK: - Methods
    func reset() {
        posts = [PostModel]()
        displayedPosts.accept(nil)
        self.loadedAllPosts.accept(false)
    }
    
    func updatePost(at index: Int) {
        guard let posts = postCollectionDisplayer.posts.value else { return }
        let post = posts[index]
        UploadingService.shared.updatePost(post: post).subscribe(onNext: { (_) in
            //Updated Post
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Methods
    func fetchLimitedPosts(for id: String) {
        
        guard let _ = Auth.auth().currentUser?.uid, !isFetching, !loadedAllPosts.value else { return }
        
        let lastPostId = posts.last?.id
        isFetching = true
        
        DispatchQueue.global(qos: .background).async  {
            
            self.getLimitedPostFetch(id: id, limit: self.fetchSteps, startId: lastPostId).subscribe(onNext: { [weak self] (posts) in
                self?.isFetching = false
                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
                self?.loadedAllPosts.accept(reachedEnd)
                self?.posts.append(contentsOf: posts)
                self?.displayedPosts.accept(self?.posts)
                
            }).disposed(by: self.disposeBag)
        }
    }
    
    //MARK: - Reactive
    func setupChildDisplayerBindables() {
        setupBindablesToChildDisplayer()
        setupBindblesFromChildDisplayer()
    }
    
    private func setupBindblesFromChildDisplayer() {
        
        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
        postCollectionDisplayer.needsRestart.filter { (needsRestart) -> Bool in
            return needsRestart
        }.subscribe(onNext: { [weak self] (_) in
            self?.start()
        }).disposed(by: disposeBag)
        
        postCollectionDisplayer.fetchNext.subscribe(onNext: { [weak self] (_) in
            guard (self?.posts.count ?? 0) > 0 else { return }
            self?.retrieveNextPosts()
        }).disposed(by: disposeBag)
        
        postCollectionDisplayer.updatePost.subscribe(onNext: { [weak self] (index) in
            self?.updatePost(at: index)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToChildDisplayer() {
        
        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
        
        Observable.combineLatest(displayingAllFetchedPosts, loadedAllPosts).map { (displayingAll, loadedAll) -> Bool in
            return displayingAll && loadedAll
            }.bind(to: postCollectionDisplayer.finished).disposed(by: disposeBag)
            
        displayedPosts.map { [weak self] (displayedPosts) -> Bool in
            guard let self = self else { return false }
            return self.posts.count == (displayedPosts?.count ?? 0)
            }.bind(to: displayingAllFetchedPosts).disposed(by: disposeBag)
        
        displayedPosts.bind(to: postCollectionDisplayer.posts).disposed(by: disposeBag)
        
    }
    
}


//
//class PostCollectionMasterViewModel: PostCollectionMasterDisplayer {
//
//    //MARK: - Models
//    var posts = [PostModel]()
//
//    //MARK: - Child Displayers
//    var postCollectionDisplayer: PostCollectionDisplayer = UserPostCollectionViewModel()
//
//    //MARK: - Variables
//    let fetchSteps: Int = 6
//    var isFetching = false
//
//    //MARK: - Bindables
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
//    //MARK: - Setup
//    init() {
//        setupBindables()
//    }
//
//    //MARK: - Methods
//
//    //This is custom and has to be conformed
//    func start() {
//        posts = [PostModel]()
//        displayedPosts.accept(nil)
//        self.loadedAllPosts.accept(false)
//
//    }
//
//    //This is custom and has to be conformed
//    func retrieveNextPosts() {
//
//    }
//
//    //MARK: - Networking
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
//    }
//
//}
