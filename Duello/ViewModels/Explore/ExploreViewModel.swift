//
//  ExploreViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class ExploreViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: ExploreCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var categories = [CategoryModel]()
    let fetchSteps: Int = 10
    
    //MARK: - Child Displayers
    //some collectionDisplayer maybe
    let categoriesViewModel = ExploreCategoryCollectionViewModel()
    
    //MARK: - Bindables
    var isFetchingCategories: Bool = false
    var loadedAllCategories: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Methods
    func start() {
        categories = [CategoryModel]()
        loadedAllCategories.accept(false)
        fetchCategories()
    }
    
    //MARK: - Networking
    func fetchCategories() {

        guard let _ = Auth.auth().currentUser?.uid, !isFetchingCategories, !loadedAllCategories.value else { return }
        
        let lastCategoryId = categories.last?.id
        isFetchingCategories = true
        
        DispatchQueue.global(qos: .background).async {
            FetchingService.shared.fetchCategories(orderKey: "creationDate", limit: self.fetchSteps, startId: lastCategoryId).subscribe(onNext: { [weak self] (categories) in
                let reachedEnd = categories.count < (self?.fetchSteps ?? 0)
                self?.loadedAllCategories.accept(reachedEnd)
                self?.categories.append(contentsOf: categories)
                self?.isFetchingCategories = false
                //
            }).disposed(by: self.disposeBag)
        }
    
//        DispatchQueue.global(qos: .background).async  {
//            FetchingService.shared.fetchUserPosts(for: uid, limit: self.fetchSteps, startId: lastCategoryId).subscribe(onNext: { [weak self] (posts) in
//                let reachedEnd = posts.count < (self?.fetchSteps ?? 0)
//                self?.loadedAllPosts.accept(reachedEnd)
//                self?.displayingAllPosts.accept(true)
//                self?.posts.append(contentsOf: posts)
//                self?.displayedPosts.append(contentsOf: posts)
//                self?.homeCollectionViewModel.posts.accept(self?.displayedPosts)
//                self?.isFetchingNextPosts = false
//                
//            }).disposed(by: self.disposeBag)
//        }
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
//        setupBindablesFromViewModel()
//        setupBindablesToViewModel()
//        setupBindablesToCoordinator()
//        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesFromViewModel() {
        
    }
    
    private func setupBindablesToViewModel() {
        
    }

    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
    }
    
}
