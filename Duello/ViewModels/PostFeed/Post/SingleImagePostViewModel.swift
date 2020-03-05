//
//  SingleImagePostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class SingleImagePostViewModel: PostViewModel {
    
    //MARK: - Models
    var singleImageModel: SingleImagePostModel {
        return post as! SingleImagePostModel
    }
    
    //MARK: - Bindables
    private var apiDownloadingTask: Observable<URL?>?
    var imageUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    
    //MARK: - Setup
    init(user: UserModel, post: SingleImagePostModel, index: Int) {
        
        switch post {
        case let post as LocalSingleImagePostModel:
            self.imageUrl.accept(post.getSingleImageUrl())
        case let post as ApiSingleImagePostModel:
            self.apiDownloadingTask = post.downloadSingleImageUrl()
        default:
            ()
        }
        super.init(user: user, post: post, index: index)
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    func setupBindablesFromOwnProperties() {
        apiDownloadingTask?.subscribe(onNext: { [weak self] (url) in
            self?.imageUrl.accept(url)
        }).disposed(by: disposeBag)
    }
    
}

