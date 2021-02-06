//
//  PostingViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryPostingViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: PostingCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    let category: CategoryModel
    
    //MARK: - Bindables
    var imageButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    var videoButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    var instagramVideoButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    var instagramImageButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Setup
    init(category: CategoryModel) {
        self.category = category
    }
    
    //MARK: - Getters
    var videosAllowed: Bool {
        return category.allowsVideos()
    }
    
    var imagesAllowed: Bool {
        return category.allowsImages()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        imageButtonTapped.bind(to: coordinator.requestedImageUpload).disposed(by: disposeBag)
        videoButtonTapped.bind(to: coordinator.requestedVideoUpload).disposed(by: disposeBag)
        instagramVideoButtonTapped.bind(to: coordinator.requestedInstagramVideoUpload).disposed(by: disposeBag)
        instagramImageButtonTapped.bind(to: coordinator.requestedInstagramImageUpload).disposed(by: disposeBag)
    }
}
