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
    
    //MARK: - Child Displayers
    var userHeaderDisplayer: UserHeaderDisplayer? { get } //HomeViewModel specific
    var postListDisplayer: PostListDisplayer { get }
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> { get }
    var showAdditionalLinkAlert: PublishRelay<String> { get }
    var showActionSheet: PublishRelay<ActionSheet> { get }
    var showAlert: PublishRelay<Alert> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    
    var isAppeared: BehaviorRelay<Bool> { get }
    
    //MARK: - Reactive
    var disposeBag: DisposeBag { get set }

}

extension PostCollectionDisplayer {
    //MARK: - Getter
    var hasProfileHeader: Bool {return userHeaderDisplayer != nil }
    
    //MARK: - Reactive
    func setupBasicBindables() {
        
        postListDisplayer.loadLink.bind(to: loadLink).disposed(by: disposeBag)
        postListDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postListDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        
    }
}
