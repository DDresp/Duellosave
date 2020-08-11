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
    var reportPost: PublishRelay<(ReportStatusType, String)> = PublishRelay()
    var changeFollowStatus: PublishRelay<Void> = PublishRelay()
    var isFollowed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
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
        
        isFollowed.bind(to: headerViewModel.isFollowed).disposed(by: disposeBag)
    }
    
    override func setupBindablesFromChildDisplayer() {
        super.setupBindablesFromChildDisplayer()
        
        listViewModel.reportPost.bind(to: reportPost).disposed(by: disposeBag)
        headerViewModel.changeFollowStatus.bind(to: changeFollowStatus).disposed(by: disposeBag)
        
    }
    
}
