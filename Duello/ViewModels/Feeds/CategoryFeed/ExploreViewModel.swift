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

class ExploreViewModel: CategoryCollectionMasterDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: ExploreCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var categories = [CategoryModel]()
    
    //MARK: - Child Displayers
    let categoryCollectionViewModel = ExploreCategoryCollectionViewModel()
    
    //MARK: - Variables
    let fetchSteps: Int = 20
    
    //MARK: - Bindables
    var displayedCategories: BehaviorRelay<[CategoryModel]?> = BehaviorRelay(value: nil)
    
    var isFetchingCategories: Bool = false
    var loadedAllCategories: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var addCategoryTapped: PublishSubject<Void> = PublishSubject<Void>()
    
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
                self?.isFetchingCategories = false
                let reachedEnd = categories.count < (self?.fetchSteps ?? 0)
                self?.loadedAllCategories.accept(reachedEnd)
                self?.categories.append(contentsOf: categories)
                self?.displayedCategories.accept(self?.categories)
            }).disposed(by: self.disposeBag)
        }
    
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBindablesFromViewModel()
        setupBindablesToViewModel()
        setupBindablesToCoordinator()
    }
    
    private func setupBindablesFromViewModel() {

        categoryCollectionViewModel.needsRestart.filter { (needsRestart) -> Bool in
            return needsRestart
        }.subscribe(onNext: { [weak self] (_) in
            self?.start()
            }).disposed(by: disposeBag)
        
        categoryCollectionViewModel.fetchNext.subscribe(onNext: { [weak self] (_) in
            guard (self?.categories.count ?? 0) > 0 else { return }
            self?.fetchCategories()
            }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToViewModel() {
        displayedCategories.bind(to: categoryCollectionViewModel.categories).disposed(by: disposeBag)
        loadedAllCategories.bind(to: categoryCollectionViewModel.allDataLoaded).disposed(by: disposeBag)
        
    }

    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        categoryCollectionViewModel.goToCategory.map { [weak self] (displayer) -> CategoryModel? in
            guard let displayer = displayer else { return nil }
            let category = self?.categories.first(where: { (model) -> Bool in
                let modelId = model.getId()
                let displayerId = displayer.categoryId
                return modelId == displayerId
            })
            return category
            }.bind(to: coordinator.requestedCategory).disposed(by: disposeBag)
        
        addCategoryTapped.bind(to: coordinator.requestedAddCategory).disposed(by: disposeBag)
    
}   
}
