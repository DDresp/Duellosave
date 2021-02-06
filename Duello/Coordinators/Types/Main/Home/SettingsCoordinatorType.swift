//
//  SettingsCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 11/17/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SettingsCoordinatorType: FlowCoordinatorType {
    var requestedCancel: PublishRelay<Void> { get }
    var didSetUser: PublishRelay<UserModel?> { get }
    
}
