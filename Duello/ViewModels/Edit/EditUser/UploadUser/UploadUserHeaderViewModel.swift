//
//  UploadUserHeaderViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class UploadUserHeaderViewModel: UploadUserHeaderDisplayer {
    
    //MARK: - Variables
    var initialImageUrl: String? = nil
    
    //MARK: - Bindables
    var image: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)
    var imageButtonTapped: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
    
}
