//
//  UploadPostDescriptionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class UploadPostDescriptionViewModel: UploadPostDescriptionDisplayer {
    
    //MARK: - Variables
    var maxCharacters: Int = 1000
    
    //MARK: - Bindables
    var rawDescription: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var description: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var didBeginEditing: PublishRelay<Void> = PublishRelay<Void>()
    var didEndEditing: PublishRelay<Void> = PublishRelay<Void>()
    var numberOfCharacters: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var showPlaceHolderLabel: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var descriptionIsValid: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        rawDescription.asDriver().map { [weak self] (text) -> String? in
            guard let self = self else { return nil }
            if let text = text, text.count > self.maxCharacters {
                let substring = text.prefix(self.maxCharacters)
                let newText = String(substring)
                return newText
            } else {
                return text
            }
            }.asObservable().bind(to: description).disposed(by: disposeBag)
        
        description.asDriver().map { (text) -> Int in
            guard let text = text else { return 0}
            return text.count
            }.drive(numberOfCharacters).disposed(by: disposeBag)
        
        description.asDriver().map { (description) -> Bool in
            if let text = description, text.count > 0 {
                return true
            } else {
                return false
            }
            }.drive(showPlaceHolderLabel).disposed(by: disposeBag)
        
        description.asDriver().map { (description) -> Bool in
            if let text = description, text.count > 0, text.count <= self.maxCharacters {
                return true
            } else {
                return false
            }
            }.drive(descriptionIsValid).disposed(by: disposeBag)
        
        Observable.of(didBeginEditing, didEndEditing).merge().withLatestFrom(description).map { (text) -> Bool in
            if let text = text, text.count > 0 {
                return true
            } else {
                return false
            }
            }.bind(to: showPlaceHolderLabel).disposed(by: disposeBag)
    }
    
}
