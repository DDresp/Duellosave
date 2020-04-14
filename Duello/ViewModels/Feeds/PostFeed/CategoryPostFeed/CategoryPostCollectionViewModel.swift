//
//  CategoryPostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryPostCollectionViewModel: PostCollectionViewModel {
    
    //MARK: - Models
    var category: BehaviorRelay<CategoryModel?> = BehaviorRelay<CategoryModel?>(value: nil)
    
    //MARK: - Child ViewModels
    var headerViewModel: CategoryHeaderViewModel {
        return postHeaderDisplayer as! CategoryHeaderViewModel
    }
    
    var listViewModel: CategoryPostListViewModel {
        return postListDisplayer as! CategoryPostListViewModel
    }
    
    //MARK: - Bindables
    var reportAsInWrongCategory: PublishRelay<String> = PublishRelay<String>()
    var reportAsFromFakeUser: PublishRelay<String> = PublishRelay<String>()
    var reportAsInappropriate: PublishRelay<String> = PublishRelay<String>()
    
    //MARK: - Setup
    init() {
        super.init(listDisplayer: CategoryPostListViewModel(), headerDisplayer: CategoryHeaderViewModel())
    }
    
    //MARK: - Reactive
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        
        category.subscribe(onNext: { [weak self] (category) in
            guard let category = category else { return }
            self?.headerViewModel.category.accept(category)
        }).disposed(by: disposeBag)
        
    }
    
    override func setupBindablesFromChildDisplayer() {
        super.setupBindablesFromChildDisplayer()
        
        listViewModel.reportAsInWrongCategory.bind(to: reportAsInWrongCategory).disposed(by: disposeBag)
        listViewModel.reportAsFromFakeUser.bind(to: reportAsFromFakeUser).disposed(by: disposeBag)
        listViewModel.reportAsInappropriate.bind(to: reportAsInappropriate).disposed(by: disposeBag)
        
    }
    
}
