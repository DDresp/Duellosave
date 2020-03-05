//
//  ImagesPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ImagesPostViewModel: PostViewModel {
    
    //MARK: - Models
    var imagesModel: ImagesPostModel {
        return post as! ImagesPostModel
    }
    
    //MARK: - ChildViewModels
    lazy var imagesSliderDisplayer: ImagesSliderDisplayer = ImagesSliderViewModel()
    
    //MARK: - Bindables
    private var apiDownloadingTask: Observable<[URL]?>?
    var postImageUrls: BehaviorRelay<[URL]?> = BehaviorRelay(value: nil)
    var selectedPhotoIndex: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    
    //MARK: - Setup
    init(user: UserModel, post: ImagesPostModel, index: Int) {
        
        switch post {
        case let post as LocalImagesPostModel:
            self.postImageUrls.accept(post.getImageURLS())
        case let post as ApiImagesPostModel:
            self.apiDownloadingTask = post.downloadImageUrls()
        default:
            ()
        }
        super.init(user: user, post: post, index: index)
        socialMediaDisplayer.user.accept(user)
        setupBindablesFromChildViewModels()
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private func setupBindablesFromChildViewModels() {
        imagesSliderDisplayer.selectedImageIndex.asObservable().bind(to: selectedPhotoIndex).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromOwnProperties() {
        apiDownloadingTask?.flatMap { (imageUrls) in
            return Observable.from(optional: imageUrls)
            }.bind(to: postImageUrls).disposed(by: disposeBag)
        
        postImageUrls.subscribe(onNext: { [weak self] (urls) in
            guard let urls = urls else { return }
            self?.imagesSliderDisplayer.imageUrls.accept(urls)
        }).disposed(by: disposeBag)
    }
    
}
