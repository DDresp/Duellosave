//
//  PostCollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PostCollectionDisplayer: class, CollectionDisplayer {
    
    //MARK: - Models
    var posts: BehaviorRelay<[PostModel]?> { get }
    
    //MARK: - Child Displayers
    var headerDisplayer: UserHeaderDisplayer? { get }
    var postListDisplayer: PostListDisplayer { get }
    
    //MARK: - Bindables
    //from Parent
    var allDataLoaded: BehaviorRelay<Bool> { get }
    var viewIsAppeared: BehaviorRelay<Bool> { get }
    
    //to Parent
    var needsRestart: BehaviorRelay<Bool> { get }
    var fetchNext: PublishRelay<Void> { get }
    var updatePost: PublishRelay<Int> { get }
    
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    //From UI (CollectionView)
    var refreshChanged: PublishSubject<Void> { get }
    var uiLoaded: BehaviorRelay<Bool> { get }
    var requestDataForIndexPath: PublishRelay<[IndexPath]> { get }
    
    //To UI
    var insertData: PublishRelay<(Int, Int)> { get }
    var reloadData: PublishRelay<Void> { get }
    var updateLayout: PublishRelay<Void> { get  }
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }
    
}

//MARK: - DEFAULT FUNCTIONALITY
extension PostCollectionDisplayer {
    //MARK: - Getter
    var hasHeader: Bool { return headerDisplayer != nil }
    var hasNoPosts: Bool { return posts.value?.count == 0 || posts.value?.count == nil }
    
    //MARK: - Methods
    func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let numberOfPosts = posts.value?.count else { return false }
        let closeToCurrrentEnd = indexPath.row >= numberOfPosts - 4
        return closeToCurrrentEnd
    }
    
    //MARK: - Reactive
    func setupDisplayerBindables() {
        setupChildDisplayerBindables()
        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesFromOwnProperties() {
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
    
    private func setupBindablesToChildDisplayer() {
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
    
    private func setupBindablesFromChildDisplayer() {
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postListDisplayer.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        postListDisplayer.reload.bind(to: reloadData).disposed(by: disposeBag)
        postListDisplayer.insert.bind(to: insertData).disposed(by: disposeBag)
        postListDisplayer.updateLayout.bind(to: updateLayout).disposed(by: disposeBag)
        
        postListDisplayer.willDisplayCell.map { (index) -> [IndexPath] in
            return [IndexPath(item: index, section: 0)]
        }.bind(to: requestDataForIndexPath).disposed(by: disposeBag)
    }
}
