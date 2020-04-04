//
//  UploadCategoryDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadCategoryDisplayer: class, UploadDisplayer {
    
    //MARK: - Child Displayers
    var titleDisplayer: UploadTitleDisplayer { get }
    var descriptionDisplayer: UploadDescriptionDisplayer { get }
    var typeSelectorDisplayer: UploadRoughTypeSelectorDisplayer { get }
    
}
