//
//  UploadCategoryViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import RxCocoa
import RxSwift
import Firebase

class UploadCategoryViewModel: UploadCategoryDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: UploadCategoryCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - ChildViewModels
    var titleDisplayer: UploadTitleDisplayer = UploadTitleViewModel()
    var descriptionDisplayer: UploadDescriptionDisplayer = UploadDescriptionViewModel(maxCharacters: 1000)
    var roughMediaSelectorDisplayer: UploadRoughMediaSelectorDisplayer = UploadRoughMediaSelectorViewModel()
    
    //MARK: - Variables
    var progressHudMessage: String = "Uploading Category"
    
    //MARK: - Bindables
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var cancelTapped: PublishSubject<Void>? = PublishSubject<Void>()
    var image: BehaviorRelay<UIImage?> = BehaviorRelay<UIImage?>(value: nil)
    var imageButtonTapped: BehaviorRelay<Void> = BehaviorRelay<Void>(value: ())
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var isLoading = BehaviorRelay(value: false)
    
    //MARK: - Setup
    init(){
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    func dataIsValid() -> Bool {
        
        if image.value == nil {
            alert.accept(Alert(alertMessage: "You need a cover image.", alertHeader: "Not Finished"))
            return false
        }
        
        if !titleDisplayer.titleIsValid.value {
            alert.accept(Alert(alertMessage: "You need a title.", alertHeader: "Not Finished"))
            return false
        }
        if !descriptionDisplayer.descriptionIsValid.value {
            alert.accept(Alert(alertMessage: "You need a description and the description can't exceed \(descriptionDisplayer.maxCharacters) characters", alertHeader: "Not Finished"))
            return false
        }
        
        if !roughMediaSelectorDisplayer.mediaTypeIsSelected.value {
            alert.accept(Alert(alertMessage: "You need to allow at least one MediaType", alertHeader: "Not Finished"))
            return false
        }
        
        return true
    }
    
    //MARK: - Methods
    private func makeCategory(imageUrl: String) -> CategoryModel {
        let category = Category()
        category.setImageUrl(imageUrl)
        category.setDescription(descriptionDisplayer.description.value ?? "")
        category.setTitle(titleDisplayer.title.value ?? "")
        category.setCreationDate(Date().timeIntervalSince1970)
        category.setMediaType(roughMediaSelectorDisplayer.mediaType.value ?? RoughMediaEnum.image)
        category.setReportStatus(CategoryReportStatusEnum.noReport)
        category.setNumberOfPosts(0)
        category.setUID(Auth.auth().currentUser?.uid ?? "")
        category.setIsActive(false)
        return category
    }
    
    //MARK: - Networking
    func saveData() {
        if !dataIsValid() { return }
        isLoading.accept(true)
        
        guard let image = image.value else {
            isLoading.accept(false)
            return
        }

        StoringService.shared.storeCoverImage(image: image).flatMapLatest { [weak self] (imageUrl) -> Observable<CategoryModel?> in
            let category = self?.makeCategory(imageUrl: imageUrl)
            return UploadingService.shared.create(category: category)
            }.subscribe(onNext: { [weak self] (_) in
                self?.isLoading.accept(false)
                self?.coordinator?.didSaveCategory.accept(())
                }, onError: { [weak self] (error) in
                    self?.isLoading.accept(false)
                    if let uploadError = error as? DuelloError {
                        self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                        print("error: ", error.localizedDescription)
                    }
            }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    let disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        submitTapped.subscribe(onNext: { [weak self] () in
            self?.saveData()
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else {
            return
        }
        cancelTapped?.bind(to: coordinator.canceled).disposed(by: disposeBag)
        imageButtonTapped.bind(to: coordinator.requestedImageUpload).disposed(by: disposeBag)
    }
    
}
