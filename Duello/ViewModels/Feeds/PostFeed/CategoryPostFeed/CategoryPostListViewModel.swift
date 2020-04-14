//
//  CategoryPostListViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryPostListViewModel: PostListViewModel {
    
    //MARK: - Bindables
    var reportAsInWrongCategory: PublishRelay<String> = PublishRelay<String>()
    var reportAsFromFakeUser: PublishRelay<String> = PublishRelay<String>()
    var reportAsInappropriate: PublishRelay<String> = PublishRelay<String>()
    
    //MARK: - Setup
    init() {
        var postViewModelOptions = PostViewModelOptions()
        postViewModelOptions.allowsReport = true
        super.init(optionsForPostViewModels: postViewModelOptions)
    }
    
    //MARK: - Methods
    override func configurePostDisplayer(for postDisplayer: PostDisplayer) {
        super.configurePostDisplayer(for: postDisplayer)
        postDisplayer.reportAsInWrongCategory.bind(to: reportAsInWrongCategory).disposed(by: disposeBag)
        postDisplayer.reportAsFromFakeUser.bind(to: reportAsFromFakeUser).disposed(by: disposeBag)
        postDisplayer.reportAsInappropriate.bind(to: reportAsInappropriate).disposed(by: disposeBag)
    }
    
}
