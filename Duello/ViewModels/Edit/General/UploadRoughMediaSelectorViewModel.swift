//
//  UploadPostTypeSelectorViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class UploadRoughMediaSelectorViewModel: UploadRoughMediaSelectorDisplayer {
    
    //MARK: - Bindables
    var imagesIsOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var videoIsOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var mediaTypeIsSelected: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var mediaType: BehaviorRelay<RoughMediaEnum?> = BehaviorRelay(value: nil)
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        
        Observable.combineLatest(imagesIsOn, videoIsOn).map { (imagesIsOn, videoIsOn) -> RoughMediaEnum? in
            if imagesIsOn && videoIsOn {
                return .videoAndImage
            } else if imagesIsOn {
                return .image
            } else if videoIsOn {
                return .video
            } else {
                return nil
            }
            }.bind(to: mediaType).disposed(by: disposeBag)
        
        mediaType.map { (mediaType) -> Bool in
            return mediaType != nil
            }.bind(to: mediaTypeIsSelected).disposed(by: disposeBag)
        
    }
    
}

