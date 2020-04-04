//
//  ExploreCategoryCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ExploreCategoryCollectionViewModel {
    
    //MARK: - Models
    var categories: BehaviorRelay<[CategoryModel]?> = BehaviorRelay<[CategoryModel]?>(value: nil)
    
    //MARK: - Child Displayers
    //maybe categorylistdisplayer here
//    var postListDisplayer: PostListDisplayer = HomePostListViewModel()
    
    //MARK: - Bindables
    var finished: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var startFetching: PublishRelay<Void> = PublishRelay()
    var fetchNext: PublishRelay<Void> = PublishRelay()

    var refreshChanged: PublishSubject<Void> = PublishSubject()
    
    var reloadData: PublishRelay<(Int, Int)> = PublishRelay()
    var restartData: PublishRelay<Void> = PublishRelay()
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Methods
    private func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let numberOfCategories = categories.value?.count else { return false }
        let closeToCurrrentEnd = indexPath.row >= numberOfCategories - 4
        return closeToCurrrentEnd
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
//        setupBasicBindables()
//        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
//        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesToChildViewModels() {
        
        categories.subscribe(onNext: { [weak self] (categories) in
            guard let categories = categories else { return }
            
            let categoryNames = categories.map { (category) -> String in
                return category.getTitle()
            }
            print("debug: observing categories from here = \(categoryNames)")
//            if self?.needsRestart.value == true {
//                self?.postListDisplayer.update(with: posts, fromStart: true)
//                self?.needsRestart.accept(false)
//            } else {
//                self?.postListDisplayer.update(with: posts, fromStart: false)
//            }
            
        }).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromChildViewModels() {
        
//        userHeaderViewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
//        userHeaderViewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
//
//        postListViewModel.insert.bind(to: reloadData).disposed(by: disposeBag)
//        postListViewModel.updateLayout.bind(to: updateLayout).disposed(by: disposeBag)
        
//        postListViewModel.restart.bind(to: restartData).disposed(by: disposeBag)
//        postListViewModel.willDisplayCell.map { (index) -> [IndexPath] in
//            return [IndexPath(item: index, section: 0)]
//            }.bind(to: requestDataForIndexPath).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromOwnProperties() {
        
        refreshChanged.map { (_) -> Bool in
            return true
        }.bind(to: needsRestart).disposed(by: disposeBag)

        requestDataForIndexPath.subscribe(onNext: { [weak self] (indexPaths) in
            guard let self = self else { return }
            if indexPaths.contains(where: self.shouldPaginate) {
                self.fetchNext.accept(())
            }
        }).disposed(by: disposeBag)
    }
    
}

