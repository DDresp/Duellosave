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
    var userHeaderDisplayer: UserHeaderDisplayer? { get }
    var postCollectionDisplayer: PostCollectionDisplayer { get }
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var viewIsAppeared: BehaviorRelay<Bool> { get }

    var finishedStart: BehaviorRelay<Bool> { get }
    var restart: PublishRelay<Void> { get }
    
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
        
        restart.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.startFetching()
        }).disposed(by: disposeBag)
        
        restart.map { (_) -> Bool in
            return false
            }.bind(to: finishedStart).disposed(by: disposeBag)
        
        postCollectionDisplayer.requestNextPosts.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.fetchNextPosts()
        }).disposed(by: disposeBag)
        postCollectionDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postCollectionDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postCollectionDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postCollectionDisplayer.refreshChanged.bind(to: restart).disposed(by: disposeBag)
        
    }
}
