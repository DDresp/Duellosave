//
//  HomeCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol HomeCoordinatorType: RootCoordinatorType {
    var loggedOut: PublishSubject<Void> { get }
    var requestedSettings: PublishSubject<UserModel> { get }
    var requestedEditing: PublishSubject<UserModel>{ get }
}
