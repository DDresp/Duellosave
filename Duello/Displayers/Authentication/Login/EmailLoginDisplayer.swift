//
//  EmailLoginDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EmailLoginDisplayer {
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var password: BehaviorRelay<String?> { get }
    var email: BehaviorRelay<String?> { get }
    var emailIsValid: BehaviorRelay<Bool> { get }
    var isLoggingIn: BehaviorRelay<Bool> { get }
    var userIsLoggedIn: BehaviorRelay<Bool> { get }
    var loginTapped: PublishRelay<Void> { get }
    var clearTextEntries: PublishRelay<Void> { get }
    
}
