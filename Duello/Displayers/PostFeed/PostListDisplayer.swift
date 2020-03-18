//
//  PostCollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PostListDisplayer: class {
    
    //MARK: - Definitions
    typealias UserPost = (UserModel, PostModel)
    
    //MARK: - Bindables
    var prefetchingIndexPaths: PublishRelay<[IndexPath]> { get }
    var requestNextPosts: PublishRelay<Void> { get }
    
    //Specific: HomeViewModel
    var deletePost: PublishRelay<String> { get }
    var updatePost: PublishRelay<Int> { get }
    //
    
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }
    var didEndDisplayingCell: PublishRelay<Int> { get }
    var willDisplayCell: PublishRelay<Int> { get }
    
    var refreshChanged: PublishSubject<Void> { get }
    var restartData: PublishRelay<Void> { get }
    var reloadData: PublishRelay<Void> { get }
    var updateLayout: PublishRelay<Void> { get }
    
    var finishedStart: BehaviorRelay<Bool> { get }
    var restart: PublishRelay<Void> { get }
    
    //MARK: - Getters
    var numberOfPostDisplayers: Int { get }
    var loadedAllPosts: Bool { get }
    var noPostsAvailable: Bool { get }
    func getPostDisplayer(at index: Int) -> PostDisplayer?
    
    //MARK: - Methods
    func update(with userPosts: [UserPost], totalPostsCount: Int?, fromStart: Bool)
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }
    
}

extension PostListDisplayer {
    
    func setupBasicBindables() {
        
        restart.map { (_) -> Bool in
            return false
            }.bind(to: finishedStart).disposed(by: disposeBag)
        
         refreshChanged.bind(to: restart).disposed(by: disposeBag)
        
    }
}
