//
//  ImagesSliderViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class ImagesSliderViewModel: ImagesSliderDisplayer {
    
    //MARK: - Bindables
    var selectedImageIndex: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var imageUrls: BehaviorRelay<[URL]?> = BehaviorRelay(value: nil)
    var images: BehaviorRelay<[UIImage]?> = BehaviorRelay(value: nil)
    
}
