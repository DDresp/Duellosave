//
//  PostCollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/18/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PostCollectionDisplayer: class {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> { get }
    var posts: BehaviorRelay<[PostModel]?> { get }
  
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postListDisplayer: PostListDisplayer { get }
    
    //MARK: - Bindables
    var finished: BehaviorRelay<Bool> { get }
    var needsRestart: BehaviorRelay<Bool> { get }
    
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }
    var refreshChanged: PublishSubject<Void> { get }
    var uiLoaded: BehaviorRelay<Bool> { get }
    
    var reloadData: PublishRelay<(Int, Int)> { get }
    var restartData: PublishRelay<Void> { get }
    var updateLayout: PublishRelay<Void> { get  }
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> { get }

    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }

}

extension PostCollectionDisplayer {
    //MARK: - Getter
    var hasProfileHeader: Bool { return userHeaderDisplayer != nil }
    var hasNoPosts: Bool { return posts.value?.count == 0 }
    
    //MARK: - Reactive
    func setupBasicBindables() {
        
        needsRestart.filter { (needsRestart) -> Bool in
            return needsRestart
        }.map { (_) -> Bool in
            return false
        }.bind(to: uiLoaded).disposed(by: disposeBag)
        
        refreshChanged.map { (_) -> Bool in
            return true
        }.bind(to: needsRestart).disposed(by: disposeBag)
        
        isAppeared.bind(to: postListDisplayer.isAppeared).disposed(by: disposeBag)
        
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
    }
}
