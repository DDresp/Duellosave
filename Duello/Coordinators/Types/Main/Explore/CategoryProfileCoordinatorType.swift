//
//  CategoryProfileCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift

protocol CategoryProfileCoordinatorType: FlowCoordinatorType {
    var requestedAddContent: PublishSubject<Void> { get }
    var goBack: PublishSubject<Void> { get }
}
