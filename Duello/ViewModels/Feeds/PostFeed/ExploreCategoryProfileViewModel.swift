//
//  CategoryProfileViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/6/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class ExploreCategoryProfileViewModel: SimplePostCollectionMasterViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: CategoryProfileCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var category: CategoryModel
    
    //MARK: - View Model
    var collectionViewModel: CategoryPostCollectionViewModel {
        return postCollectionDisplayer as! CategoryPostCollectionViewModel
    }
    
    //MARK: - Bindables
    let requestedAddContent: PublishSubject<Void> = PublishSubject()
    let goBack: PublishSubject<Void> = PublishSubject()
    
    //MARK: - Setup
    init(category: CategoryModel) {
        self.category = category
        super.init(postCollectionDisplayer: CategoryPostCollectionViewModel(), fetchSteps: 6) { (limit, startId) -> Observable<[PostModel]> in
            return FetchingService.shared.fetchCategoryPosts(for: category.getId(), limit: limit, startId: startId)
        }
    }
    
    //MARK: - Methods
    override func start() {
        super.start()
        collectionViewModel.category.accept(category)
    }
    
    func reportInappropriatePost(for postId: String) {
        UploadingService.shared.createInappropriateReport(postId: postId).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    func reportInWrongCategoryPost(for postId: String) {
        UploadingService.shared.createWrongCategoryReport(postId: postId).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    func reportFromFakeUserPost(for postId: String) {
        UploadingService.shared.createFromFakeUserReport(postId: postId).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    
    //MARK: - Reactive
    override func setupBindblesFromChildDisplayer() {
        super.setupBindblesFromChildDisplayer()
        
        collectionViewModel.reportAsInappropriate.subscribe(onNext: { (postId) in
            self.reportInappropriatePost(for: postId)
        }).disposed(by: disposeBag)
        
        collectionViewModel.reportAsInWrongCategory.subscribe(onNext: { [weak self] (postId) in
            self?.reportInWrongCategoryPost(for: postId)
        }).disposed(by: disposeBag)
        
        collectionViewModel.reportAsFromFakeUser.subscribe(onNext: { (postId) in
            self.reportFromFakeUserPost(for: postId)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        requestedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)
        goBack.bind(to: coordinator.goBack).disposed(by: disposeBag)
    }
    
}
