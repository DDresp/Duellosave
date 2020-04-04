//
//  UploadPostTitleDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UploadTitleDisplayer {
    
    //MARK: - Bindables
    var title: BehaviorRelay<String?> { get }
    var titleIsValid: BehaviorRelay<Bool> { get }
    
}
