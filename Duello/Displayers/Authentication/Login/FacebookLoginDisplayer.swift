//
//  FacebookLoginDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FacebookLoginDisplayer {
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var isLoggingIn: BehaviorRelay<Bool> { get }
    var userIsLoggedIn: BehaviorRelay<Bool> { get }
    var viewControllerFacebookLogin: UIViewController? { get set }
    var started: PublishSubject<Void> { get }
    
}
