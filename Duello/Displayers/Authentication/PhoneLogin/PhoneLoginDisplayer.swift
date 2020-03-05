//
//  PhoneLoginDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PhoneLoginDisplayer {
    
    //MARK: - Variables
    var progressHudMessage: String? { get }
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var phoneNumberSubmitTapped: PublishSubject<Void> { get }
    var countryCode: BehaviorRelay<String?> { get }
    var phoneNumberWithoutCountryCode: BehaviorRelay<String?> { get }
    var verificationCode: BehaviorRelay<String?> { get }
    var verificationCodeSubmitTapped: PublishSubject<Void> { get }
    var showPhoneNumberVerificationView: BehaviorRelay<Bool> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var cancelTapped: PublishSubject<Void> { get }

}
