//
//  PostingCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol PostingCoordinatorType: FlowCoordinatorType {
    var requestedVideoUpload: PublishSubject<Void> { get }
    var requestedImageUpload: PublishSubject<Void> { get }
    var requestedInstagramVideoUpload: PublishSubject<Void> { get }
    var requestedInstagramImageUpload: PublishSubject<Void> { get }
    var uploadedMedia: BehaviorRelay<Bool> { get }
}
