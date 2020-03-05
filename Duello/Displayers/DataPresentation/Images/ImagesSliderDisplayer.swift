//
//  ImagesSliderDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ImagesSliderDisplayer {
    
    //MARK: - Bindables
    var selectedImageIndex: BehaviorRelay<Int> { get }
    var imageUrls: BehaviorRelay<[URL]?> { get }
    var images: BehaviorRelay<[UIImage]?> { get }
    
}
