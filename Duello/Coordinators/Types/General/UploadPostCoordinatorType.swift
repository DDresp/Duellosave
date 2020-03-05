//
//  UploadPostCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UploadPostCoordinatorType: FlowCoordinatorType {
    var didSavePost: PublishRelay<Void> { get }
}

