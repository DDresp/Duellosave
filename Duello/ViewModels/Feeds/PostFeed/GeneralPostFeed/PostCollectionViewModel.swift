//
//  PostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/9/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class PostCollectionViewModel: PostCollectionDisplayer {
    
    //MARK: - Models
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - Child Displayers
    var postHeaderDisplayer: PostHeaderDisplayer?
    var postListDisplayer: PostListDisplayer
    
    //MARK: - Bindables
    
    //from Parent
    var allDataLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var viewIsAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var collectionViewScrolled: PublishRelay<Void> = PublishRelay()
    
    //to Parent
    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var fetchNext: PublishRelay<Void> = PublishRelay()
    var updatePost: PublishRelay<Int> = PublishRelay()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //From UI (CollectionView)
    var refreshChanged: PublishSubject<Void> = PublishSubject()
    var uiLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    var changeActivationStatusPost: PublishRelay<(Bool, String)> = PublishRelay()
    
    //To UI
    var insertData: PublishRelay<(Int, Int)> = PublishRelay()
    var reloadData: PublishRelay<Void> = PublishRelay()
    var updateLayout: PublishRelay<Void> = PublishRelay()
    
    //MARK: - Setup
    init(listDisplayer: PostListDisplayer, headerDisplayer: PostHeaderDisplayer?) {
        self.postListDisplayer = listDisplayer
        self.postHeaderDisplayer = headerDisplayer
        setupBindables()
    }
    
    //MARK: - Methods
    func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let numberOfPosts = posts.value?.count else { return false }
        let closeToCurrrentEnd = indexPath.row >= numberOfPosts - 4
        return closeToCurrrentEnd
    }
    
    //MARK: - Reactive
    var disposeBag: DisposeBag = DisposeBag()
    
    func setupBindables() {
        setupDisplayerBindables()
    }
    
    func setupDisplayerBindables() {
        setupChildDisplayerBindables()
        setupBindablesFromOwnProperties()
    }
    
    func setupBindablesFromOwnProperties() {
        needsRestart.filter { (needsRestart) -> Bool in
            return needsRestart
        }.map { (_) -> Bool in
            return false
        }.bind(to: uiLoaded).disposed(by: disposeBag)
        
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
    
    private func setupChildDisplayerBindables() {
        setupBindablesToChildDisplayer()
        setupBindablesFromChildDisplayer()
    }
    
    func setupBindablesToChildDisplayer() {
        viewIsAppeared.bind(to: postListDisplayer.isAppeared).disposed(by: disposeBag)
        
        posts.subscribe(onNext: { [weak self] (posts) in
            guard let posts = posts else { return }
            if self?.needsRestart.value == true {
                self?.postListDisplayer.update(with: posts, fromStart: true)
                self?.needsRestart.accept(false)
            } else {
                self?.postListDisplayer.update(with: posts, fromStart: false)
            }
        }).disposed(by: disposeBag)
    }
    
    func setupBindablesFromChildDisplayer() {
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postListDisplayer.showAlert.bind(to: showAlert).disposed(by: disposeBag)
//        postListDisplayer.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        postListDisplayer.changeActivationStatusPost.bind(to: changeActivationStatusPost).disposed(by: disposeBag)
        
        postListDisplayer.reload.bind(to: reloadData).disposed(by: disposeBag)
        postListDisplayer.insert.bind(to: insertData).disposed(by: disposeBag)
        postListDisplayer.updateLayout.bind(to: updateLayout).disposed(by: disposeBag)
        
        postListDisplayer.willDisplayCell.map { (index) -> [IndexPath] in
            return [IndexPath(item: index, section: 0)]
        }.bind(to: requestDataForIndexPath).disposed(by: disposeBag)
    }
    
}
