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
    var titleDisplayer: UploadTitleDisplayer { get }
    var descriptionDisplayer: UploadDescriptionDisplayer { get }
    
    //MARK: - Variables
    var mediaRatio: Double? { get }
    
    //MARK: - Bindables
    var didDisappear: PublishRelay<Void> { get }
    
}
