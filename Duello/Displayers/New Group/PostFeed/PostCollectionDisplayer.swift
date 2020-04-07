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
//    var user: BehaviorRelay<UserModel?> { get }
    var posts: BehaviorRelay<[PostModel]?> { get }
  
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postListDisplayer: PostListDisplayer { get }
    
    //MARK: - Bindables
    var needsRestart: BehaviorRelay<Bool> { get }
    var fetchNext: PublishRelay<Void> { get }
    var updatePost: PublishRelay<Int> { get }
    
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }
    var refreshChanged: PublishSubject<Void> { get }
    var uiLoaded: BehaviorRelay<Bool> { get }
    
    var insertData: PublishRelay<(Int, Int)> { get }
    var reloadData: PublishRelay<Void> { get }
    var updateLayout: PublishRelay<Void> { get  }
    
    var requestDataForIndexPath: PublishRelay<[IndexPath]> { get }

    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }

}

extension PostCollectionDisplayer {
    //MARK: - Getter
    var hasProfileHeader: Bool { return userHeaderDisplayer != nil }
    var hasNoPosts: Bool { return posts.value?.count == 0 }
    
}
