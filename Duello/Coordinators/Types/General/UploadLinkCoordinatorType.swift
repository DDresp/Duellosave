//
//  UploadLinkCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadLinkCoordinatorType: FlowCoordinatorType {
    var canceledLinkUpload: PublishRelay<Void> { get }
    var data: PublishRelay<RawInstagramPostType> { get }
    
}
