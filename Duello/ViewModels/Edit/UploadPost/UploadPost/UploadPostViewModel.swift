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
    let category: CategoryModel
    
    var post: T? {
        didSet {
            initialisePost()
        }
    }
    
    //MARK: - Coordinator
    weak var coordinator: UploadPostCoordinatorType?
    
    //MARK: - ChildViewModels
    var titleDisplayer: UploadTitleDisplayer = UploadTitleViewModel()
    var descriptionDisplayer: UploadDescriptionDisplayer = UploadDescriptionViewModel(maxCharacters: 1000)
    
    //MARK: - Variables
    var progressHudMessage: String = "Uploading Post"
    var mediaRatio: Double? = nil
    
    //MARK: - Bindables
    var didDisappear: PublishRelay<Void> = PublishRelay()
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var cancelTapped: PublishSubject<Void>? = nil //cancel not possible
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoading = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(category: CategoryModel){
        self.category = category
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
    func initialisePost() {
        guard let uploadPost = post else { return }
        uploadPost.setDescription(descriptionDisplayer.description.value)
        uploadPost.setTitle(titleDisplayer.title.value)
        uploadPost.setCreationDate(Date().timeIntervalSince1970)
        let likes = Int(arc4random_uniform(12) + 1)
        let dislikes = Int(arc4random_uniform(12) + 1)
        uploadPost.setLikes(likes)
        uploadPost.setDislikes(dislikes)
        let rate: Double = Double(likes)/Double(likes + dislikes)
        uploadPost.setRate(rate)
        uploadPost.setMediaRatio(mediaRatio)
        uploadPost.setUID(Auth.auth().currentUser?.uid)
        uploadPost.setCID(category.getId())
        uploadPost.setCategory(category)
        
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
