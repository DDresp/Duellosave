//
//  UploadPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import Firebase

class UploadPostViewModel<T: PostModel>: UploadPostDisplayer {
    
    //MARK: - Models
    var post: T? {
        didSet {
            initialisePost()
        }
    }
    
    //MARK: - Coordinator
    weak var coordinator: UploadPostCoordinatorType?
    
    //MARK: - ChildViewModels
    var titleDisplayer: UploadPostTitleDisplayer = UploadPostTitleViewModel()
    var descriptionDisplayer: UploadPostDescriptionDisplayer = UploadPostDescriptionViewModel()
    
    //MARK: - Variables
    var progressHudMessage: String = "Uploading Post"
    var mediaRatio: Double? = nil
    
    //MARK: - Bindables
    var didDisappear: PublishRelay<Void> = PublishRelay()
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoading = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(){
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    func dataIsValid() -> Bool {
        if !titleDisplayer.titleIsValid.value {
            alert.accept(Alert(alertMessage: "You need a title.", alertHeader: "Not Finished"))
            return false
        }
        if !descriptionDisplayer.descriptionIsValid.value {
            alert.accept(Alert(alertMessage: "You need a description and the description can't exceed \(descriptionDisplayer.maxCharacters) characters", alertHeader: "Not Finished"))
            return false
        }
        return true
    }
    
    //MARK: - Methods
    private func initialisePost() {
        guard let uploadPost = post else { return }
        uploadPost.description.value = descriptionDisplayer.description.value
        uploadPost.title.value = titleDisplayer.title.value
        uploadPost.creationDate.value = Date().timeIntervalSince1970
        let likes = Int(arc4random_uniform(12) + 1)
        let dislikes = Int(arc4random_uniform(12) + 1)
        uploadPost.likes.value = likes
        uploadPost.dislikes.value = dislikes
        let rate: Double = Double(likes)/Double(likes + dislikes)
        uploadPost.rate.value = rate
        uploadPost.mediaRatio.value = mediaRatio ?? 1
        uploadPost.uid.value = Auth.auth().currentUser?.uid
    }
    
    //MARK: - Networking
    func saveData() {
        if !dataIsValid() { return }
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        submitTapped.subscribe(onNext: { [weak self] () in
            self?.saveData()
        }).disposed(by: disposeBag)
    }
    
}
