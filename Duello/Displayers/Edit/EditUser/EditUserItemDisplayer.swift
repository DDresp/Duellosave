//
//  UploadUserItemDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EditUserItemDisplayer {
    
    //MARK: - Variables
    var itemType: EditUserItemViewModel.ItemType { get }
    
    //MARK: - Bindables
    var name: BehaviorRelay<String?> { get }
    var nameIsEdited: BehaviorRelay<Bool> { get }
    var addedName: BehaviorRelay<Bool> { get }
    var nameTooLong: BehaviorRelay<Bool> { get }
    var link: BehaviorRelay<String?>? { get }
    var linkIsEdited: BehaviorRelay<Bool>? { get }
    var linkHasName: BehaviorRelay<Bool>? { get }
    var linkTooLong: BehaviorRelay<Bool>? { get }
    
    //MARK: - Getters
    var title: String { get }
    var namePlaceholderString: String { get }
    var iconName: String? { get }
    var hasIcon: Bool { get }
    var hasDefaultLink: Bool { get }
    var userCanAddLink: Bool { get }
    var linkPrefix: String? { get }
    
}
