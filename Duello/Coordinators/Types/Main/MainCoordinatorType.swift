//
//  MainCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MainCoordinatorType: FlowCoordinatorType {
    var loggedOut: PublishSubject<Void> { get }
}
