//
//  UploadInstagramLinkDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadInstagramLinkDisplayer: class, UploadLinkDisplayer {
    //MARK: - Reactive
    var disposeBag: DisposeBag { get }
    
}

extension UploadInstagramLinkDisplayer {
    
    func setupDefaultBindables() {
        
        link.asObservable().map { (text) -> Bool in
            return text?.isValidInstagramLink() ?? false
            }.bind(to: linkIsValid).disposed(by: disposeBag)
        
        
        submitTapped.subscribe(onNext: { [weak self] (_) in
            self?.downloadLink()
        }).disposed(by: disposeBag)
        
    }
    
    func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        cancelTapped.asObservable().bind(to: coordinator.canceledLinkUpload).disposed(by: disposeBag)
    }
    
}
