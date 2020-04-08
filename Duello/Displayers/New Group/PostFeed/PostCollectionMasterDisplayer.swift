//
//  FeedDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

protocol PostCollectionMasterDisplayer: class {
    
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
    
    var viewIsAppeared: BehaviorRelay<Bool> { get }

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

//MARK: - DEFAULT FUNCTIONALITY
extension PostCollectionMasterDisplayer {
    
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
    func setupDisplayerBindables() {
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
