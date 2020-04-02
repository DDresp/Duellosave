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
    var titleDisplayer: UploadPostTitleDisplayer { get }
    var descriptionDisplayer: UploadPostDescriptionDisplayer { get }
    var typeSelectorDisplayer: UploadPostTypeSelectorDisplayer { get }
    
    //MARK: - Bindables
    var submitTapped: PublishSubject<Void> { get }
    var cancelTapped: PublishSubject<Void> { get }
    
}
