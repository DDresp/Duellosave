//
//  CategoryCreationCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CategoryCreationCoordinatorType: RootCoordinatorType {
    var requestedCategoryUpload: PublishSubject<Void> { get }
}
