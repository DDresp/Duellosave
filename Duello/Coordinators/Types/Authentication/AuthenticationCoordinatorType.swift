//
//  AuthenticationCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AuthenticationCoordinatorType: FlowCoordinatorType {
    
    var loggedIn: PublishSubject<Void> { get }
    var phoneLoginRequested: PublishSubject<Void> { get }
    var authenticationCompleted: PublishSubject<Void> { get }
    
}
