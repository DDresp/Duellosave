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
    var isFollowed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
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
        fetchCategoryFollowStatus()
    }
    
    func fetchCategoryFollowStatus() {
        
        guard let categoryId = category.id else { return }
        
        DispatchQueue.global(qos: .background).async  {
            
            FetchingService.shared.fetchFollowStatus(for: categoryId).subscribe(onNext: { [weak self] (isFollowed) in
                self?.isFollowed.accept(isFollowed)
            }).disposed(by: self.disposeBag)
            
        }
        
    }
    
    //MARK: - Networking
    func reportPost(for postId: String, report: ReportStatusType) {
        UploadingService.shared.createReport(postId: postId, report: report).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    func changeFollowStatus() {
        
        guard let categoryId = category.id else { return }
        if isFollowed.value {
            isFollowed.accept(!self.isFollowed.value)
            DeletingService.shared.unfollowCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //unfollow category
                }).disposed(by: disposeBag)
        } else {
            isFollowed.accept(!self.isFollowed.value)
            UploadingService.shared.followCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //followed category
            }).disposed(by: disposeBag)
        }
        
    }
    
    //MARK: - Reactive
    override func setupBindblesFromChildDisplayer() {
        super.setupBindblesFromChildDisplayer()
        
        collectionViewModel.reportPost.subscribe(onNext: { [weak self] (report, postId) in
            self?.reportPost(for: postId, report: report)
            }).disposed(by: disposeBag)
        
        collectionViewModel.changeFollowStatus.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.changeFollowStatus()
            }).disposed(by: disposeBag)
        
    }
    
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        isFollowed.bind(to: collectionViewModel.isFollowed).disposed(by: disposeBag)
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        requestedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)
        goBack.bind(to: coordinator.goBack).disposed(by: disposeBag)
    }
    
}
