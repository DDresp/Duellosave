//
//  SimplePostCollectionMasterViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class SimplePostCollectionMasterViewModel: PostCollectionMasterDisplayer {
    
    //MARK: - Models
    var posts = [PostModel]()
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer
    
    //MARK: - Variables
    let fetchSteps: Int
    let postFetch: (Int, String?) -> Observable<[PostModel]>
    var isFetching = false
    
    //MARK: - Bindables
    var displayedPosts: BehaviorRelay<[PostModel]?> = BehaviorRelay(value: nil)
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var displayingAllFetchedPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(postCollectionDisplayer: PostCollectionDisplayer, fetchSteps: Int, postFetch: @escaping (Int, String?) -> Observable<[PostModel]>) {
        self.fetchSteps = fetchSteps
        self.postCollectionDisplayer = postCollectionDisplayer
        self.postFetch = postFetch
        setupBindables()
    }
    
    //MARK: - Methods
    func reset() {
        posts = [PostModel]()
        displayedPosts.accept(nil)
        self.loadedAllPosts.accept(false)
    }
    
    func start() {
        fetchLimitedPosts()
    }
    
    func retrieveNextPosts() {
        fetchLimitedPosts()
    }

    func changeActivationStatus(for postId: String, isActivated: Bool) {
        
        guard let posts = postCollectionDisplayer.posts.value else { return }
        let post = posts.first { (post) -> Bool in
            return post.id == postId
        }
        
        guard let toUpdatePost = post else { return }
        toUpdatePost.isDeactivated.setValue(of: !isActivated)
        
        UploadingService.shared.updatePost(post: toUpdatePost).subscribe(onNext: { (_) in
            //updated Post
            }).disposed(by: disposeBag)

    }
    
    func fetchLimitedPosts() {
        
        guard let _ = Auth.auth().currentUser?.uid, !isFetching, !loadedAllPosts.value else { return }
        
        let lastPostId = posts.last?.id
        isFetching = true
        
        DispatchQueue.global(qos: .background).async  {
            
            self.postFetch(self.fetchSteps, lastPostId).subscribe(onNext: { [weak self] (posts) in
                self?.isFetching = false
                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
                self?.loadedAllPosts.accept(reachedEnd)
                self?.posts.append(contentsOf: posts)
                self?.displayedPosts.accept(self?.posts)
                
            }).disposed(by: self.disposeBag)
        }
    }
    
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupDisplayerBindables()
    }
    
    func setupDisplayerBindables() {
        setupBindablesToChildDisplayer()
        setupBindblesFromChildDisplayer()
    }
    
    func setupBindblesFromChildDisplayer() {
        
        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postCollectionDisplayer.showAlert.bind(to: showAlert).disposed(by: disposeBag)
        
        postCollectionDisplayer.needsRestart.filter { (needsRestart) -> Bool in
            return needsRestart
        }.subscribe(onNext: { [weak self] (_) in
            self?.reset()
            self?.start()
        }).disposed(by: disposeBag)
        
        postCollectionDisplayer.fetchNext.subscribe(onNext: { [weak self] (_) in
            guard (self?.posts.count ?? 0) > 0 else { return }
            self?.retrieveNextPosts()
        }).disposed(by: disposeBag)
        
        postCollectionDisplayer.changeActivationStatusPost.subscribe(onNext: { [weak self] (isActivated, postId) in
            self?.changeActivationStatus(for: postId, isActivated: isActivated)
            }).disposed(by: disposeBag)
        
    }
    
    func setupBindablesToChildDisplayer() {
        
        viewIsAppeared.bind(to: postCollectionDisplayer.viewIsAppeared).disposed(by: disposeBag)
        
        Observable.combineLatest(displayingAllFetchedPosts, loadedAllPosts).map { (displayingAll, loadedAll) -> Bool in
            return displayingAll && loadedAll
            }.bind(to: postCollectionDisplayer.allDataLoaded).disposed(by: disposeBag)
            
        displayedPosts.map { [weak self] (displayedPosts) -> Bool in
            guard let self = self else { return false }
            return self.posts.count == (displayedPosts?.count ?? 0)
            }.bind(to: displayingAllFetchedPosts).disposed(by: disposeBag)
        
        displayedPosts.bind(to: postCollectionDisplayer.posts).disposed(by: disposeBag)
        
    }
    
}

