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
    let goBack: PublishSubject<Void> = PublishSubject()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var displayingAllFetchedPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedAllPosts: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(category: CategoryModel) {
        self.category = category
        setupBindables()
    }
    
    //MARK: - Methods
    func start() {
        reset()
        fetchLimitedPosts(for: category.getId())
    }
    
    func retrieveNextPosts() {
        fetchLimitedPosts(for: category.getId())
    }
    
    //MARK: - Getters
    func getLimitedPostFetch(id: String, limit: Int, startId: String?) -> Observable<[PostModel]> {
        return FetchingService.shared.fetchCategoryPosts(for: id, limit: limit, startId: startId)
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupDisplayerBindables()
    }

    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        requestedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)
        goBack.bind(to: coordinator.goBack).disposed(by: disposeBag)
    }
    
}

