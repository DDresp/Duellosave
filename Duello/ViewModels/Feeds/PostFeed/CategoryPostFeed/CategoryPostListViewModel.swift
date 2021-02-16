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
    var reportPost: PublishRelay<(PostReportStatusType, String)> = PublishRelay()
    
    //MARK: - Setup
    init() {
        var postViewModelOptions = PostViewModelOptions()
        postViewModelOptions.allowsReport = true
        super.init(optionsForPostViewModels: postViewModelOptions)
    }
    
    //MARK: - Methods
    override func configurePostDisplayer(for postDisplayer: PostDisplayer) {
        super.configurePostDisplayer(for: postDisplayer)
        postDisplayer.reportMe.bind(to: reportPost).disposed(by: disposeBag)
    }
    
}
