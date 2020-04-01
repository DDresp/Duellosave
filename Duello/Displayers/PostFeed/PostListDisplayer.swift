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
    
    //MARK: - Bindables
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }
    var didEndDisplayingCell: PublishRelay<Int> { get }
    var willDisplayCell: PublishRelay<Int> { get }
    
    //MARK: - Getters
    var numberOfPostDisplayers: Int { get }
//    var loadedAllPosts: Bool { get }
//    var loadedAllPostsTest: Bool { get }
//    var noPostsAvailable: Bool { get }
    func getPostDisplayer(at index: Int) -> PostDisplayer?
    
    //MARK: - Methods
    func update(with userPosts: [PostModel], fromStart: Bool)
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }
    
}

//
//import RxSwift
//import RxCocoa
//
//protocol PostListDisplayer: class {
//
//    //MARK: - Bindables
//    var showActionSheet: PublishRelay<ActionSheet> { get }
//    var loadLink: PublishRelay<String?> { get }
//    var showAdditionalLinkAlert: PublishRelay<String> { get }
//
//    var isAppeared: BehaviorRelay<Bool> { get }
//    var didEndDisplayingCell: PublishRelay<Int> { get }
//    var willDisplayCell: PublishRelay<Int> { get }
//
//    //MARK: - Getters
//    var numberOfPostDisplayers: Int { get }
////    var loadedAllPosts: Bool { get }
////    var loadedAllPostsTest: Bool { get }
////    var noPostsAvailable: Bool { get }
//    func getPostDisplayer(at index: Int) -> PostDisplayer?
//
//    //MARK: - Methods
//    func update(with userPosts: [UserPost], fromStart: Bool)
//
//    //MARK: - Reactive
//    var disposeBag: DisposeBag { get set }
//
//}
