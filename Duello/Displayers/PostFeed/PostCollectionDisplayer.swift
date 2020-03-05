//
//  PostCollectionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PostCollectionDisplayer {
    
    //MARK: - Definitions
    typealias UserPost = (UserModel, PostModel)
    
    //MARK: - Bindables
    var prefetchingIndexPaths: PublishRelay<[IndexPath]> { get }
    var updateLayout: PublishRelay<Bool> { get }
    var needsUpdate: PublishRelay<Void> { get }
    var deleteItem: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var didEndDisplayingCell: PublishRelay<Int> { get }
    var willDisplayCell: PublishRelay<Int> { get }
    var viewDidDisappear: PublishRelay<Void> { get }
    
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    
    //MARK: - Getters
    var numberOfPostDisplayers: Int { get }
    var loadedAllPosts: Bool { get }
    var noPostsAvailable: Bool { get }
    func getPostDisplayer(at index: Int) -> PostDisplayer?
    
    //MARK: - Methods
    func update(with userPosts: [UserPost], totalPostsCount: Int?)
    
}
