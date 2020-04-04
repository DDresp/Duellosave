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
    var titleDisplayer: UploadPostTitleDisplayer = UploadPostTitleViewModel()
    var descriptionDisplayer: UploadPostDescriptionDisplayer = UploadPostDescriptionViewModel()
    var typeSelectorDisplayer: UploadPostTypeSelectorDisplayer = UploadPostTypeSelectorViewModel()
    
    //MARK: - Variables
    var progressHudMessage: String = "Uploading Category"
    
    //MARK: - Bindables
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var cancelTapped: PublishSubject<Void> = PublishSubject<Void>()
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
        
        if !typeSelectorDisplayer.mediaTypeIsSelected.value {
            alert.accept(Alert(alertMessage: "You need to allow at least one MediaType", alertHeader: "Not Finished"))
            return false
        }
        
        return true
    }
    
    //MARK: - Methods
    private func makeCategory() -> CategoryModel {
        let category = Category()
        category.description.value = descriptionDisplayer.description.value
        category.title.value = titleDisplayer.title.value
        category.creationDate.value = Date().timeIntervalSince1970
        category.typeData.value = typeSelectorDisplayer.mediaType.value
        return category
    }
    
    //MARK: - Networking
    func saveData() {
        if !dataIsValid() { return }
        isLoading.accept(true)
        
        let category = makeCategory()
        
        UploadingService.shared.create(category: category).subscribe(onNext: { [weak self] (_) in
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
        cancelTapped.bind(to: coordinator.canceled).disposed(by: disposeBag)
    }
    
}
