//
//  UserHeaderViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UserHeaderViewModel: UserHeaderDisplayer {
    
    //MARK: - Models
    var user: BehaviorRelay<UserModel?> = BehaviorRelay<UserModel?>(value: nil)
    
    //MARK: - ChildViewModels
    var socialMediaViewModel: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: true)
    
    //MARK: - Variables
    var totalRate: Double?
    var imageUrl: String?
    var userName: String?
    var hasSocialMediaNames = false
    
    //MARK: - Bindables
    var totalRateNeedsAnimation: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var imageTapped: PublishRelay<Void> = PublishRelay<Void>()
    var cleanUser: PublishRelay<Void> = PublishRelay<Void>()

    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        user.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.isLoading.accept(false)
            self?.imageUrl = user?.imageUrl.value?.toStringValue()
            self?.userName = user?.userName.value?.toStringValue()
            self?.hasSocialMediaNames = user?.addedSocialMediaName ?? false
            self?.socialMediaViewModel.user.accept(user)
            self?.totalRate = user?.score
            if let _ = user?.score {
                self?.totalRateNeedsAnimation.accept(true)
            }
            
            self?.cleanUser.accept(())
        }).disposed(by: disposeBag)
        
        cleanUser.asObservable().bind(to: socialMediaViewModel.cleanCache).disposed(by: disposeBag)
    }

}
