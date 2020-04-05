//
//  ExploreCategoryCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryCollectionViewModel: CategoryCollectionDisplayer {
    
    //MARK: - Models
    var categories: BehaviorRelay<[CategoryModel]?> = BehaviorRelay<[CategoryModel]?>(value: nil)
    
    //MARK: - Child Displayers
    var categoryListDisplayer: CategoryListDisplayer = ExploreCategoryListViewModel()
    
    //MARK: Child ViewModels
    var exploreCategoryListViewModel: ExploreCategoryListViewModel {
        return categoryListDisplayer as! ExploreCategoryListViewModel
    }
    
    //MARK: - Variables
    var hasNoCategories: Bool { return categories.value?.count == 0 }
    
    //MARK: - Bindables
    var finished: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var startFetching: PublishRelay<Void> = PublishRelay()
    var fetchNext: PublishRelay<Void> = PublishRelay()

    var refreshChanged: PublishSubject<Void> = PublishSubject()
    
    var insertData: PublishRelay<(Int, Int)> = PublishRelay()
    var reloadData: PublishRelay<Void> = PublishRelay()
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Methods
    private func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let numberOfCategories = categories.value?.count else { return false }
        let closeToCurrrentEnd = indexPath.row >= numberOfCategories - 4
        return closeToCurrrentEnd
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesToChildViewModels() {
        
        categories.subscribe(onNext: { [weak self] (categories) in
            guard let categories = categories else { return }
            
            if self?.needsRestart.value == true {
                self?.categoryListDisplayer.update(with: categories, fromStart: true)
                self?.needsRestart.accept(false)
            } else {
                self?.categoryListDisplayer.update(with: categories, fromStart: false)
            }
            
        }).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromChildViewModels() {
        
        categoryListDisplayer.insert.bind(to: insertData).disposed(by: disposeBag)
        categoryListDisplayer.reload.bind(to: reloadData).disposed(by: disposeBag)
        
        categoryListDisplayer.willDisplayCell.map { (index) -> [IndexPath] in
            return [IndexPath(item: index, section: 0)]
            }.bind(to: requestDataForIndexPath).disposed(by: disposeBag)
        
        exploreCategoryListViewModel.goToCategory.subscribe(onNext: { (category) in
            print("debug: go to category: \(category?.title ?? "no title")")
            }).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromOwnProperties() {
        
        refreshChanged.map { (_) -> Bool in
            return true
        }.bind(to: needsRestart).disposed(by: disposeBag)

        requestDataForIndexPath.subscribe(onNext: { [weak self] (indexPaths) in
            guard let self = self else { return }
            if indexPaths.contains(where: self.shouldPaginate) {
                self.fetchNext.accept(())
            }
        }).disposed(by: disposeBag)
    }
    
}

