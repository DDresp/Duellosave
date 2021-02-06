//
//  SingleImagePostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class SingleImagePostViewModel: PostViewModel, SingleImagePostDisplayer {
    
    //MARK: - Models
    var singleImageModel: SingleImagePostModel {
        return post as! SingleImagePostModel
    }
    
    //MARK: - Bindables
    private var apiDownloadingTask: Observable<URL?>?
    var imageUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    
    //MARK: - Setup
    init(post: SingleImagePostModel, index: Int, options: PostViewModelOptions) {
        
        switch post {
        case let post as LocalSingleImagePostModel:
            self.imageUrl.accept(post.getSingleImageUrl())
        case let post as ApiSingleImagePostModel:
            self.apiDownloadingTask = post.downloadSingleImageUrl()
        default:
            ()
        }
        super.init(post: post, index: index, options: options)
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    func setupBindablesFromOwnProperties() {
        
        apiDownloadingTask?.subscribe(onNext: { [weak self] (url) in
            self?.imageUrl.accept(url)
            self?.isDeactivated.accept(false)
        }, onError: { [weak self] (err) in
            if let error = err as? InstagramError, case .deactive = error {
                self?.isDeactivated.accept(true)
            }
            }).disposed(by: disposeBag)
    }
    
}

