//
//  RegistrationDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RegistrationDisplayer: class {
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var password: BehaviorRelay<String?> { get }
    var passwordIsValid: BehaviorRelay<Bool> { get }
    var confirmedPassword: BehaviorRelay<String?> { get }
    var confirmedPasswordIsValid: BehaviorRelay<Bool> { get }
    var email: BehaviorRelay<String?> { get }
    var emailIsValid: BehaviorRelay<Bool> { get }
    var isRegistering: BehaviorRelay<Bool> { get }
    var registrationTapped: PublishRelay<Void> { get }
    var clearTextEntries: PublishRelay<Void> { get }
    
}
