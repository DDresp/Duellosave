//
//  UploadLinkDisplayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UploadLinkDisplayer {
    
    //MARK: - Coordinator
    var coordinator: UploadLinkCoordinatorType? { get set }
    
    //MARK: - Variables
    var apiDomain: String { get }
    var progressHudMessage: String { get }
    
    //MARK: - Bindables
    //to view
    var alert: PublishRelay<Alert> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var linkIsValid: BehaviorRelay<Bool> { get }
    
    //from view
    var link: BehaviorRelay<String?> { get }
    var cancelTapped: PublishSubject<Void> { get }
    var nextTapped: PublishSubject<Void> { get }
    
    //MARK: - Networking
    func downloadLink()
}
