//
//  FeedDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FeedDisplayer: class {
    
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get } //HomeViewModel specific
    var postListDisplayer: PostListDisplayer { get }
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var viewIsAppeared: BehaviorRelay<Bool> { get }
    
    //MARK: - Methods
    func startFetching() -> ()
    func fetchNextPosts() -> ()
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }

}

extension FeedDisplayer {
    //MARK: - Getter
    var hasProfileHeader: Bool {return userHeaderDisplayer != nil }
    
    //MARK: - Reactive
    func setupBasicBindables() {
        
        postListDisplayer.restart.subscribe(onNext: { [weak self] (_) in
            self?.startFetching()
        }).disposed(by: disposeBag)

        postListDisplayer.requestNextPosts.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.fetchNextPosts()
        }).disposed(by: disposeBag)
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
    }
}
