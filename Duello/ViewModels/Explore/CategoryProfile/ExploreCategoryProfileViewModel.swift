//
//  CategoryProfileViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/6/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class ExploreCategoryProfileViewModel: PostCollectionMasterDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: CategoryProfileCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var category: CategoryModel
    var posts = [PostModel]()
    
    //MARK: - Child Displayers
    var postCollectionDisplayer: PostCollectionDisplayer = CategoryPostCollectionViewModel()
    
    //MARK: - Variables
    let fetchSteps: Int = 6
    var isFetching = false
    
    //MARK: - Bindables
    var displayedPosts: BehaviorRelay<[PostModel]?> = BehaviorRelay(value: nil)
    
    let requestedAddContent: PublishSubject<Void> = PublishSubject()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var displayingAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(category: CategoryModel) {
        self.category = category
        setupBindables()
    }
    
    //MARK: - Methods
    func start() {
        posts = [PostModel]()
        self.loadedAllPosts.accept(false)
        
        fetchLimitedPosts()
    }
    
    func retrieveNextPosts() {
        fetchLimitedPosts()
    }
    
    //MARK: - Networking
    func fetchLimitedPosts() {
        
        guard let _ = Auth.auth().currentUser?.uid, !isFetching, !loadedAllPosts.value else { return }
        
        let lastPostId = posts.last?.id
        let cid = category.getId()
        isFetching = true
        DispatchQueue.global(qos: .background).async {
            FetchingService.shared.fetchCategoryPosts(for: cid, limit: self.fetchSteps, startId: lastPostId).subscribe(onNext: { [weak self] (posts) in
                self?.isFetching = false
                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
                self?.loadedAllPosts.accept(reachedEnd)
                self?.posts.append(contentsOf: posts)
                self?.displayedPosts.accept(self?.posts)
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func updatePost(at index: Int) {
        guard let posts = postCollectionDisplayer.posts.value else { return }
        let post = posts[index]
        UploadingService.shared.updatePost(post: post).subscribe(onNext: { (_) in
            //Updated Post
            }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBindablesFromViewModel()
        setupBindablesToViewModel()
        setupBindablesToCoordinator()
    }
    
    private func setupBindablesFromViewModel() {

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
    
    private func setupBindablesToViewModel() {
        
        isAppeared.bind(to: postCollectionDisplayer.isAppeared).disposed(by: disposeBag)
        
        Observable.combineLatest(displayingAllPosts, loadedAllPosts).map { (displayingAll, loadedAll) -> Bool in
            return displayingAll && loadedAll
            }.bind(to: postCollectionDisplayer.finished).disposed(by: disposeBag)
            
        displayedPosts.map { [weak self] (displayedPosts) -> Bool in
            guard let self = self else { return false }
            return self.posts.count == (displayedPosts?.count ?? 0)
            }.bind(to: displayingAllPosts).disposed(by: disposeBag)
        
        displayedPosts.bind(to: postCollectionDisplayer.posts).disposed(by: disposeBag)
        
    }

    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        requestedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)

    }
    
}

