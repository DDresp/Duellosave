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
    var isFavorite: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
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
        fetchCategoryFavoriteStatus()
    }
    
    func fetchCategoryFavoriteStatus() {
        
        guard let categoryId = category.id else { return }
        
        DispatchQueue.global(qos: .background).async  {
            
            FetchingService.shared.fetchFavoriteStatus(for: categoryId).subscribe(onNext: { [weak self] (isFavorite) in
                self?.isFavorite.accept(isFavorite)
            }).disposed(by: self.disposeBag)
            
        }
        
    }
    
    //MARK: - Networking
    func reportPost(for postId: String, report: ReportStatusType) {
        UploadingService.shared.createReport(postId: postId, report: report).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    func changeFavoriteStatus() {
        
        guard let categoryId = category.id, let favorite = isFavorite.value else { return }
        if favorite {
            isFavorite.accept(!favorite)
            DeletingService.shared.unfavorCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //unfavored category
                }).disposed(by: disposeBag)
        } else {
            isFavorite.accept(!favorite)
            UploadingService.shared.favorCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //favored category
            }).disposed(by: disposeBag)
        }
        
    }
    
    //MARK: - Reactive
    override func setupBindblesFromChildDisplayer() {
        super.setupBindblesFromChildDisplayer()
        
        collectionViewModel.reportPost.subscribe(onNext: { [weak self] (report, postId) in
            self?.reportPost(for: postId, report: report)
            }).disposed(by: disposeBag)
        
        collectionViewModel.changeFavoriteStatus.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.changeFavoriteStatus()
            }).disposed(by: disposeBag)
        
    }
    
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        isFavorite.bind(to: collectionViewModel.isFavorite).disposed(by: disposeBag)
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        requestedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)
        goBack.bind(to: coordinator.goBack).disposed(by: disposeBag)
    }
    
}
