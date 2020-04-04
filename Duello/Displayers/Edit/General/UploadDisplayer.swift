//
//  UploadDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadDisplayer {
    
    //MARK: - Variables
    var progressHudMessage: String { get }
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    
    var submitTapped: PublishSubject<Void> { get }
    var cancelTapped: PublishSubject<Void>? { get }

    //MARK: - Methods
    func dataIsValid() -> Bool
    
    //MARK: - Networking
    func saveData() -> ()
    
}
