//
//  UploadPostTitleViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class UploadPostTitleViewModel: UploadPostTitleDisplayer {
    
    //MARK: - Bindables
    var title: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var titleIsValid: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        title.asDriver().map { (title) -> Bool in
            if let title = title, title.count > 0, title.count < 150 {
                return true
            } else {
                return false
            }
            }.drive(titleIsValid).disposed(by: disposeBag)
    }
    
}
