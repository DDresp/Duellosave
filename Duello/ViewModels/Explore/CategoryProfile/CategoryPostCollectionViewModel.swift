//
//  CategoryPostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryPostCollectionViewModel: PostCollectionDisplayer {
    
    //MARK: - Models
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - Child Displayers
    var headerDisplayer: UserHeaderDisplayer? = UserHeaderViewModel()
    var postListDisplayer: PostListDisplayer = UserPostListViewModel()
    
    //MARK: - Child ViewModels
    var postListViewModel: UserPostListViewModel {
        return postListDisplayer as! UserPostListViewModel
    }
    
    //MARK: - Bindables
    
    //from Parent
    var allDataLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //to Parent
    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var fetchNext: PublishRelay<Void> = PublishRelay()
    var updatePost: PublishRelay<Int> = PublishRelay()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //From UI (CollectionView)
    var refreshChanged: PublishSubject<Void> = PublishSubject()
    var uiLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    
    //To UI
    var insertData: PublishRelay<(Int, Int)> = PublishRelay()
    var reloadData: PublishRelay<Void> = PublishRelay()
    var updateLayout: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupDisplayerBindables()
    }
    
}
