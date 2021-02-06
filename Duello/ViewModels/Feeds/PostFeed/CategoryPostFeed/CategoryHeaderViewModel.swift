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
    //from UI
    var tappedFollow: PublishRelay<Void> = PublishRelay()
    var changeFollowStatus: PublishRelay<Void> = PublishRelay()
    
    //to UI
    var isFollowed: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    //MARK: - Getters
    var title: String? {
        return category.value?.getTitle()
    }
    
    var description: String? {
        return category.value?.getDescription()
    }
    
    
    //MARK: - Setup
    init() {
        setupBindablesFromUI()
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromUI() {
        tappedFollow.bind(to: changeFollowStatus).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromOwnProperties() {
        
        category.subscribe(onNext: { (_) in
            //DO nothing for now
        }).disposed(by: disposeBag)
        
    }
    
}
