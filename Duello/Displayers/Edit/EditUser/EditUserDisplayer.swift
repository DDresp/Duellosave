//
//  UploadUserDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EditUserDisplayer: UploadDisplayer {
    
    //MARK: - Variables
    var numberOfSections: Int { get }
    
    //MARK: - Bindables
    var showImagePickerView: PublishSubject<Void> { get }
    
    //MARK: - Getters
    func getUploadUserItemDisplayer(at index: Int) -> EditUserItemDisplayer
    func getUploadUserHeaderDisplayer() -> EditUserHeaderDisplayer
    
}
