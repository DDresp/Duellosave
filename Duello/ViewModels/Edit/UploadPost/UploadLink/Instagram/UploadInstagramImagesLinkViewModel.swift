//
//  UploadInstagramImagesLinkViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

class UploadInstagramImagesLinkViewModel: UploadInstagramLinkDisplayer {
    
    //MARK: - Reactive
    weak var coordinator: UploadLinkCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Variables
    var apiDomain: String = "Instagram"
    var progressHudMessage: String = "loading"
    
    //MARK: - Bindables
    var link: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var linkIsValid = BehaviorRelay(value: false)
    
    var alert: PublishRelay<Alert> = PublishRelay()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var nextTapped: PublishSubject<Void> = PublishSubject()
    
    //MARK: - Setup
    init() {
        setupDefaultBindables()
    }
    
    //MARK: - Networking
    func downloadLink() {
        guard linkIsValid.value, let link = link.value else {
            alert.accept(Alert(alertMessage: "Please provide a valid url to Instagram", alertHeader: "Invalid"))
            return
        }
        self.isLoading.accept(true)
        InstagramService.shared.downloadInstagramImagesPost(from: link).subscribe(onNext: { [weak self] (rawInstagramPost) in
            self?.isLoading.accept(false)
            self?.coordinator?.data.accept(rawInstagramPost)
            }, onError: { [weak self] (error) in
                self?.isLoading.accept(false)
                if let instagramError = error as? InstagramError {
                    self?.alert.accept(Alert(alertMessage: instagramError.errorMessage, alertHeader: instagramError.errorHeader))
                }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
}
