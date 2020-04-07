//
//  CategoryPostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/7/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryPostCollectionViewModel: PostCollectionDisplayer {
    
    //MARK: - Models
    
    //Sometimes Category, sometimes User
//    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    var posts: BehaviorRelay<[PostModel]?> = BehaviorRelay<[PostModel]?>(value: nil)
    
    //MARK: - Child Displayers
    
    //Should generic HeaderDisplayer!!!
    var userHeaderDisplayer: UserHeaderDisplayer? = UserHeaderViewModel()
    var postListDisplayer: PostListDisplayer = UserPostListViewModel()
    
    //MARK: - Child ViewModels
//    var userHeaderViewModel: UserHeaderViewModel {
//        return userHeaderDisplayer as! UserHeaderViewModel
//    }
    
    var postListViewModel: UserPostListViewModel {
        return postListDisplayer as! UserPostListViewModel
    }
    
    //MARK: - Bindables
    var finished: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var needsRestart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var fetchNext: PublishRelay<Void> = PublishRelay()
    var updatePost: PublishRelay<Int> = PublishRelay()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var showAlert: PublishRelay<Alert> = PublishRelay<Alert>()
    var showLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

//    var startFetching: PublishRelay<Void> = PublishRelay()
//    var fetchNext: PublishRelay<Void> = PublishRelay()
//    var deletePost: PublishRelay<String> = PublishRelay<String>()
//    var updatePost: PublishRelay<Int> = PublishRelay<Int>()
    
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var uiLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var refreshChanged: PublishSubject<Void> = PublishSubject()
    
    var insertData: PublishRelay<(Int, Int)> = PublishRelay()
    var reloadData: PublishRelay<Void> = PublishRelay()
    var updateLayout: PublishRelay<Void> = PublishRelay()
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    
    //MARK: - Setup
    init() {
        setupBindables()
    }
    
    //MARK: - Methods
    func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let numberOfPosts = posts.value?.count else { return false }
        let closeToCurrrentEnd = indexPath.row >= numberOfPosts - 4
        return closeToCurrrentEnd
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindables() {
        setupBindablesFromChildViewModels()
        setupBindablesToChildViewModels()
        setupBindablesFromOwnProperties()
    }
    
    private func setupBindablesToChildViewModels() {
        
//        user.subscribe(onNext: { [weak self] (user) in
//            guard let user = user else { return }
//            self?.userHeaderDisplayer?.user.accept(user)
//        }).disposed(by: disposeBag)
        
        posts.subscribe(onNext: { [weak self] (posts) in
            guard let posts = posts else { return }

            if self?.needsRestart.value == true {
                self?.postListDisplayer.update(with: posts, fromStart: true)
                self?.needsRestart.accept(false)
            } else {
                self?.postListDisplayer.update(with: posts, fromStart: false)
            }
            
        }).disposed(by: disposeBag)

//        Observable.combineLatest(uiLoaded, isAppeared).filter { (started, appeared) -> Bool in
//            return started && appeared
//        }.map { (_, _) -> Void in
//            return ()
//            }.bind(to: userHeaderViewModel.animateScore).disposed(by: disposeBag)

    }
    
    private func setupBindablesFromChildViewModels() {
        
        
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
//        userHeaderViewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
//        userHeaderViewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        
        postListDisplayer.reload.bind(to: reloadData).disposed(by: disposeBag)
        postListDisplayer.insert.bind(to: insertData).disposed(by: disposeBag)
        postListDisplayer.updateLayout.bind(to: updateLayout).disposed(by: disposeBag)
        
        //homeviewmodel specific
//        postListViewModel.deletePost.bind(to: deletePost).disposed(by: disposeBag)
//        postListViewModel.updatePost.bind(to: updatePost).disposed(by: disposeBag)
        //
        
        postListDisplayer.willDisplayCell.map { (index) -> [IndexPath] in
            return [IndexPath(item: index, section: 0)]
            }.bind(to: requestDataForIndexPath).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromOwnProperties() {
        
        isAppeared.bind(to: postListDisplayer.isAppeared).disposed(by: disposeBag)
        
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
    
}
