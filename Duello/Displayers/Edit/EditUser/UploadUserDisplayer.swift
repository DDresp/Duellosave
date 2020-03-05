//
//  UploadUserDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadUserDisplayer: UploadDisplayer {
    
    //MARK: - Variables
    var numberOfSections: Int { get }
    
    //MARK: - Bindables
    var cancelTapped: PublishSubject<Void> { get }
    var submitTapped: PublishSubject<Void> { get }
    var showImagePickerView: PublishSubject<Void> { get }
    
    //MARK: - Getters
    func getUploadUserItemDisplayer(at index: Int) -> UploadUserItemDisplayer
    func getUploadUserHeaderDisplayer() -> UploadUserHeaderDisplayer
    
}
