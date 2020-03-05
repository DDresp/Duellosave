//
//  UploadPostDescriptionDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UploadPostDescriptionDisplayer {
    
    //MARK: - Variables
    var maxCharacters: Int { get }
    
    //MARK: - Bindables
    var rawDescription: BehaviorRelay<String?> { get }
    var description: BehaviorRelay<String?> { get }
    var didBeginEditing: PublishRelay<Void> { get }
    var didEndEditing: PublishRelay<Void>   { get }
    var showPlaceHolderLabel: BehaviorRelay<Bool> { get }
    var numberOfCharacters: BehaviorRelay<Int> { get }
    var descriptionIsValid: BehaviorRelay<Bool> { get }
    
}
