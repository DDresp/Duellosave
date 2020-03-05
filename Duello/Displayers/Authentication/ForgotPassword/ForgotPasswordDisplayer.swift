//
//  ForgotPasswordDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ForgotPasswordDisplayer: class {
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var email: BehaviorRelay<String?> { get }
    var emailIsValid: BehaviorRelay<Bool> { get }
    var isSendingResetEmail: BehaviorRelay<Bool> { get }
    var forgotPasswordSubmitTapped: PublishSubject<Void> { get }
    
}
