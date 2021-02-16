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
    var reportPost: PublishRelay<(PostReportStatusType, String)> = PublishRelay()
    var changeFavoriteStatus: PublishRelay<Void> = PublishRelay()
    var isFavorite: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
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
        
        isFavorite.bind(to: headerViewModel.isFavorite).disposed(by: disposeBag)
    }
    
    override func setupBindablesFromChildDisplayer() {
        super.setupBindablesFromChildDisplayer()
        
        listViewModel.reportPost.bind(to: reportPost).disposed(by: disposeBag)
        headerViewModel.changeFavoriteStatus.bind(to: changeFavoriteStatus).disposed(by: disposeBag)
        
    }
    
}
