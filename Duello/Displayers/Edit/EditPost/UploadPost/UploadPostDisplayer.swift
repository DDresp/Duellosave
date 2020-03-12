//
//  UploadPostDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadPostDisplayer: class, UploadDisplayer {
    
    //MARK: - Child Displayers
    var titleDisplayer: UploadPostTitleDisplayer { get }
    var descriptionDisplayer: UploadPostDescriptionDisplayer { get }
    
    //MARK: - Bindables
    var submitTapped: PublishSubject<Void> { get }
    var didDisappear: PublishRelay<Void> { get }
    
}
