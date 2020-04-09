//
//  CategoryHeaderViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryHeaderViewModel: PostHeaderDisplayer {
    
    //MARK: - Models
    let category: BehaviorRelay<CategoryModel?> = BehaviorRelay(value: nil)
    
    //MARK: - ChildViewModels
    
    //MARK: - Variables
    
    //MARK: - Bindables

    //MARK: - Getters
    var title: String? {
        return category.value?.getTitle()
    }
    
    var description: String? {
        return category.value?.getDescription()
    }
    
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        category.subscribe(onNext: { [weak self] (user) in
            //DO nothing for now
        }).disposed(by: disposeBag)
        
    }
    
}
