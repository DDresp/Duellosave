//
//  UploadUserHeaderDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EditUserHeaderDisplayer {
    
    //MARK: - Variables
    var initialImageUrl: String? { get set }
    
    //MARK: - Bindables
    var image: BehaviorRelay<UIImage?> { get }
    var imageButtonTapped: BehaviorRelay<Void> { get }
    
}
