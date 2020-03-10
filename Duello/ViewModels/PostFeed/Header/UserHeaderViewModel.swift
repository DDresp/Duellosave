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
    var socialMediaDisplayer: SocialMediaDisplayer = SocialMediaViewModel(isDarkMode: true)
    
    //MARK: - Variables
    var score: Double?
    
    //MARK: - Bindables
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var imageTapped: PublishRelay<Void> = PublishRelay<Void>()
    var reload: PublishRelay<Void> = PublishRelay()
//    var score: BehaviorRelay<Double?> = BehaviorRelay<Double?>(value: nil)
    var animateScore: PublishRelay<Void> = PublishRelay() //developing
    var didAppear: PublishRelay<Void> = PublishRelay()

    //MARK: - Getters
    var imageUrl: String? {
        return user.value?.imageUrl.value?.toStringValue()
    }
    
    var userName: String? {
        return user.value?.userName.value?.toStringValue()
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
        
        //Developing
//        animateScore.subscribe(onNext: { (_) in
//            print("debug: should animate score")
//        }).disposed(by: disposeBag)
//
        user.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.isLoading.accept(false)
            self?.socialMediaDisplayer.user.accept(user)
//            self?.score.accept(user?.score)
            self?.score = user?.score //Developing
            self?.socialMediaDisplayer.cleanCache.accept(())
            self?.reload.accept(())
        }).disposed(by: disposeBag)
        
        didAppear.bind(to: animateScore).disposed(by: disposeBag)
    }
    
    deinit {
        print("debug: deinit userheaderviewmodel")
    }

}
