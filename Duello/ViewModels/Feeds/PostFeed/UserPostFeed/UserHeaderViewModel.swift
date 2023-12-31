//
//  UserHeaderViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UserHeaderViewModel: PostHeaderDisplayer {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    
    //MARK: - ChildViewModels
    var socialMediaDisplayer: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: true)
    
    //MARK: - Variables
    var score: Double?
    
    //MARK: - Bindables
    var animateScore: PublishRelay<Void> = PublishRelay()

    //MARK: - Getters
    var imageUrl: String? {
        return user.value?.getImageUrl()
    }
    
    var userName: String? {
        return user.value?.getUserName()
    }
    
    var hasSocialMediaNames: Bool {
        return user.value?.addedSocialMediaName ?? false
    }
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        user.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.socialMediaDisplayer.user.accept(user)
            self?.score = user?.score
            self?.socialMediaDisplayer.cleanCache.accept(())
        }).disposed(by: disposeBag)
    }
    
}
