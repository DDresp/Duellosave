//
//  ExploreCategoryListViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class ExploreCategoryListViewModel: CategoryListDisplayer {
    
    //MARK: - ChildViewModels
    private var categoryDisplayers = [CategoryViewModel]()
    
    //MARK: - Bindables
    var willDisplayCell: PublishRelay<Int> = PublishRelay()

    var reload: PublishRelay<Void> = PublishRelay()
    var insert: PublishRelay<(Int, Int)> = PublishRelay()
    
    var goToCategory: PublishRelay<CategoryDisplayer?> = PublishRelay()
    
    //MARK: - Getters
    var numberOfCategoryDisplayers: Int { return categoryDisplayers.count }
    
    func getCategoryDisplayer(at index: Int) -> CategoryDisplayer? {
        guard index < numberOfCategoryDisplayers else { return nil }
        return categoryDisplayers[index]
    }
    
    //MARK: - Methods
    func update(with loadedCategories: [CategoryModel], fromStart: Bool) {
        
        if fromStart {
            categoryDisplayers = [CategoryViewModel]()
            disposeBag = DisposeBag()
        }
        
        if numberOfCategoryDisplayers == 0 && loadedCategories.count == 0 {
            reload.accept(())
            return
        }
        
        let startIndex = numberOfCategoryDisplayers
        let endIndex = loadedCategories.count - 1
        
        guard startIndex <= endIndex else { return }
        
        let newCategories = Array(loadedCategories[startIndex...endIndex])
        configureCategoryDisplayers(with: newCategories)

        if fromStart {
            reload.accept(())
        } else {
            insert.accept((startIndex, endIndex))
        }
    }
    
    //Configuration
    private func configureCategoryDisplayers(with categories: [CategoryModel]) {
        
        let startIndex = categoryDisplayers.count
        var newCategoryViewModels = [CategoryViewModel]()
        
        for (index, category) in categories.enumerated() {
            
            let modelIndex = startIndex + index
            let viewModel = CategoryViewModel(category: category, index: modelIndex)
            newCategoryViewModels.append(viewModel)

        }
        
        for categoryViewModel in newCategoryViewModels {
            configureCategoryDisplayer(for: categoryViewModel)
        }
        
        categoryDisplayers.append(contentsOf: newCategoryViewModels)
    
    }
    
    //Configuration of ChildPostViewModels
    private func configureCategoryDisplayer(for categoryDisplayer: CategoryDisplayer) {
        
        categoryDisplayer.goToMe.map { [weak self] (index) -> CategoryDisplayer? in
            guard let index = index else { return nil }
            return self?.getCategoryDisplayer(at: index)
        }.bind(to: goToCategory).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
}

