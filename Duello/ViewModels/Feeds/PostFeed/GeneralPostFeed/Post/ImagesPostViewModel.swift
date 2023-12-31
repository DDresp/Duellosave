//
//  ImagesPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ImagesPostViewModel: PostViewModel, ImagesPostDisplayer {
    
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
    init(post: ImagesPostModel, index: Int, options: PostViewModelOptions) {
        
        switch post {
        case let post as LocalImagesPostModel:
            self.postImageUrls.accept(post.getImageUrls())
        case let post as ApiImagesPostModel:
            self.apiDownloadingTask = post.downloadImageUrls()
        default:
            ()
        }
        super.init(post: post, index: index, options: options)
        socialMediaDisplayer.user.accept(post.getUser())
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
        }.subscribe(onNext: { [weak self] (urls) in
            self?.postImageUrls.accept(urls)
            self?.isDeactivated.accept(false)
            }, onError: { [weak self] (err) in
                if let error = err as? InstagramError, case .deactive = error {
                    self?.isDeactivated.accept(true)
                }
        }).disposed(by: disposeBag)
        
        postImageUrls.subscribe(onNext: { [weak self] (urls) in
            guard let urls = urls else { return }
            self?.imagesSliderDisplayer.imageUrls.accept(urls)
        }).disposed(by: disposeBag)
    }
}
