//
//  HomeSettingsViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 1/16/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeSettingsViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: HomeSettingsCoordinator? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Variables
    var disclosureItems = ["Edit Profile"]
    var standardItems = ["Logout"]
    
    //MARK: - Bindables
    var cancelTapped: PublishSubject<Void> = PublishSubject<Void>()
    var disclosureItemTapped: PublishSubject<Int> = PublishSubject<Int>()
    var standardItemTapped: PublishSubject<Int> = PublishSubject<Int>()
    
    //MARK: - Setup
    init() {}
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        cancelTapped.bind(to: coordinator.requestedCancel).disposed(by: disposeBag)
        
        standardItemTapped.subscribe(onNext: { (index) in
            if index == 0 {
                coordinator.requestedLogout.accept(())
            }
        }).disposed(by: disposeBag)
        
        disclosureItemTapped.subscribe(onNext: { (index) in
            if index == 0 {
                coordinator.requestedEdit.accept(())
            }
        }).disposed(by: disposeBag)
        
    }
    
}
