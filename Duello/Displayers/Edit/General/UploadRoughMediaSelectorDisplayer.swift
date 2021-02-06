//
//  UploadPostTypeSelectorDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadRoughMediaSelectorDisplayer {
    
    var imagesIsOn: BehaviorRelay<Bool> { get }
    var videoIsOn: BehaviorRelay<Bool> { get }
    var mediaTypeIsSelected: BehaviorRelay<Bool> { get }
    var mediaType: BehaviorRelay<RoughMediaType?> { get }
    
}
