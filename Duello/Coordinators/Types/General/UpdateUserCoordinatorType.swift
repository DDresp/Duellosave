//
//  UpdateUserCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UpdateUserCoordinatorType: FlowCoordinatorType {
    var canceledUserUpload: PublishRelay<Void> { get }
    var didSetUser: PublishRelay<UserModel?> { get }
    
}
