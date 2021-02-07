//
//  UploadCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadCategoryCoordinatorType: FlowCoordinatorType {
    var didSaveCategory: PublishRelay<Void> { get }
    var canceled: PublishRelay<Void> { get }
    var requestedImageUpload: PublishRelay<Void> { get }
}
