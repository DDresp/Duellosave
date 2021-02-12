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
    weak var coordinator: ExploreCategoryPostingCoordinator? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    let category: CategoryModel
    
    //MARK: - Bindables
    var cancelTapped: PublishSubject<Void> = PublishSubject<Void>()
    
    var uploadImageSelected: PublishRelay<Void> = PublishRelay<Void>()
    var uploadVideoSelected: PublishRelay<Void> = PublishRelay<Void>()
    var uploadInstagramVideoSelected: PublishRelay<Void> = PublishRelay<Void>()
    var uploadInstagramImageSelected: PublishRelay<Void> = PublishRelay<Void>()
    
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
        
        cancelTapped.bind(to: coordinator.requestedCancel).disposed(by: disposeBag)
        uploadImageSelected.bind(to: coordinator.requestedImageUpload).disposed(by: disposeBag)
        uploadVideoSelected.bind(to: coordinator.requestedVideoUpload).disposed(by: disposeBag)
        uploadInstagramVideoSelected.bind(to: coordinator.requestedInstagramVideoUpload).disposed(by: disposeBag)
        uploadInstagramImageSelected.bind(to: coordinator.requestedInstagramImageUpload).disposed(by: disposeBag)
    }
}
