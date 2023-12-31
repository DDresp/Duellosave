//
//  CategoryViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryViewModel: CategoryDisplayer {
    
    //MARK: - Models
    let category: CategoryModel
    
    //MARK: - Variables
    var index: Int
    var categoryId: String
    var imageUrl: String?
    var title: String
    var description: String
    
    //MARK: - Bindables
    var goToMe: PublishRelay<Int?> = PublishRelay()
    var tapped: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init(category: CategoryModel, index: Int) {
        self.category = category
        self.index = index
        self.categoryId = category.getId()
        self.imageUrl = category.getImageUrl()
        self.description = category.getDescription()
        self.title = category.getTitle()
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        tapped.map { [weak self] (_) -> Int? in
            return self?.index
        }.bind(to: goToMe).disposed(by: disposeBag)
    }
    
}
