//
//  UploadUserViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase
import SDWebImage

class UploadUserViewModel: EditUserDisplayer {
    
    //MARK: - Coordinator
    weak var coordinator: UpdateUserCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - ChildViewModels
    var uploadUserHeaderViewModel: EditUserHeaderDisplayer = EditUserHeaderViewModel()
    
    let itemViewModels: [EditUserItemDisplayer] = [
        EditUserItemViewModel(itemType: .username),
        EditUserItemViewModel(itemType: .instagram),
        EditUserItemViewModel(itemType: .snapchat),
        EditUserItemViewModel(itemType: .youtube),
        EditUserItemViewModel(itemType: .facebook),
        EditUserItemViewModel(itemType: .twitter),
        EditUserItemViewModel(itemType: .vimeo),
        EditUserItemViewModel(itemType: .tiktok),
        EditUserItemViewModel(itemType: .additionalLink)
    ]
    
    //MARK: - Variables
    var progressHudMessage: String = "loading"
    var isUpdating = false
    
    //MARK: - Bindables
    var alert: BehaviorRelay<Alert?> = BehaviorRelay<Alert?>(value: nil)
    var cancelTapped: PublishSubject<Void>? = PublishSubject<Void>()
    var submitTapped: PublishSubject<Void> = PublishSubject<Void>()
    var isLoading = BehaviorRelay(value: false)
    var showImagePickerView: PublishSubject<Void> = PublishSubject<Void>()

    //MARK: - Setup
    init() {
        setupBindablesFromHeader()
    }
    
    //MARK: - Getters
    var numberOfSections: Int {
        return itemViewModels.count + 1
    }
    
    func getUploadUserItemDisplayer(at index: Int) -> EditUserItemDisplayer {
        return itemViewModels[index - 1]
    }
    
    func getUploadUserHeaderDisplayer() -> EditUserHeaderDisplayer {
        return uploadUserHeaderViewModel
    }
    
    private func getName(name: String?) -> String? {
        guard let name = name else { return nil }
        return name.count > 0 ? name : nil
    }
    
    private func getLink(link: String?, linkPrefix: String?) -> String? {
        guard let link = link else { return nil }
        if let linkPrefix = linkPrefix {
            return linkPrefix == link ? nil : link
        } else {
            return link.count > 0 ? link : nil
        }
    }
    
    //Data Validation
    var itemHasMissingName: Bool {
        let itemWithInvalidName = itemViewModels.filter { (item) -> Bool in
            return !item.addedName.value
            }.first
        
        if itemWithInvalidName != nil {
            alert.accept(Alert(alertMessage: "please add \(itemWithInvalidName!.title.lowercased())", alertHeader: "Not Finished"))
            return true
        }
        return false
    }
    
    var itemHasMissingLinkName: Bool {
        let itemWithInvalidLink = itemViewModels.filter { (item) -> Bool in
            //only has property "link" if user can add link to item
            guard let linkIsValid = item.linkHasName?.value else { return false }
            return !linkIsValid
            }.first
        
        if itemWithInvalidLink != nil {
            alert.accept(Alert(alertMessage: "when you provide a link to \(itemWithInvalidLink!.title.lowercased()), you also have to provide your \(itemWithInvalidLink!.title.lowercased()) name", alertHeader: "Not Finished"))
            return true
        }
        return false
    }
    
    var itemHasTooLongName: Bool {
        let itemWithTooLongName = itemViewModels.filter { (item) -> Bool in
            return item.nameTooLong.value
            }.first
        
        if itemWithTooLongName != nil {
            alert.accept(Alert(alertMessage: "your name for \(itemWithTooLongName!.title.lowercased()) is too long", alertHeader: "Not Finished"))
            return true
        }
        return false
    }
    
    var itemHasTooLongLinkName: Bool {
        let itemWithTooLongLink = itemViewModels.filter { (item) -> Bool in
            //only has property "link" if user can add link to item
            guard let linkTooLong = item.linkTooLong?.value else { return false }
            return linkTooLong
            }.first
        if itemWithTooLongLink != nil {
            alert.accept(Alert(alertMessage: "your link to \(itemWithTooLongLink!.title.lowercased()) is too long", alertHeader: "Not Finished"))
            return true
        }
        return false
    }
    
    var itemHasMissingImage: Bool {
        if (uploadUserHeaderViewModel.image.value != nil) || (uploadUserHeaderViewModel.initialImageUrl != nil) {
            return false
        } else {
            alert.accept(Alert(alertMessage: "please provide a profile image", alertHeader: "Not Finished"))
            return true
        }
    }

    func dataIsValid() -> Bool {
        
        return !(itemHasMissingName || itemHasMissingLinkName || itemHasTooLongName || itemHasTooLongLinkName || itemHasMissingImage)
        
    }
    
    //MARK: - Methods
    private func makeUser(with imageUrl: String?) -> UserModel {
        let user = User()
        
        if !isUpdating {
            user.setCreationDate(Timestamp.init(date: Date()))
        }
        
        for item in itemViewModels {
            switch item.itemType {
            case .username:
                user.setUserName(item.name.value ?? "Default User Name")
            case .instagram:
                let instaName = getName(name: item.name.value?.trimmingCharacters(in: .whitespacesAndNewlines))
                user.setInstagramName(instaName)
                if let name = instaName {
                    user.setInstagramLink("https://www.instagram.com/\(name)/")
                }
            case .snapchat:
                let snapName = getName(name: item.name.value?.trimmingCharacters(in: .whitespacesAndNewlines))
                user.setSnapchatName(snapName)
                if let name = snapName {
                    user.setSnapchatLink("https://www.snapchat.com/add/\(name)/")
                }
            case .youtube:
                user.setYoutubeName(getName(name: item.name.value))
                user.setYoutubeLink(getLink(link: item.link?.value, linkPrefix: item.linkPrefix))
            case .facebook:
                user.setFacebookName(getName(name: item.name.value))
                user.setFacebookLink(getLink(link: item.link?.value, linkPrefix: item.linkPrefix))
            case .twitter:
                let twiName = getName(name: item.name.value?.trimmingCharacters(in: .whitespacesAndNewlines))
                user.setTwitterName(twiName)
                if let name = twiName {
                    user.setTwitterLink("https://twitter.com/\(name)/")
                }
            case .vimeo:
                user.setVimeoName(getName(name: item.name.value))
                user.setVimeoLink(getLink(link: item.link?.value, linkPrefix: item.linkPrefix))
            case .tiktok:
                user.setTikTokName(getName(name: item.name.value))
            case .additionalLink:
                user.setAdditionalName(getName(name: item.name.value))
                user.setAdditionalLink(getLink(link: item.link?.value, linkPrefix: item.linkPrefix))
            }
        }
        
        user.setImageUrl(imageUrl)
        
        return user
    }
    
    //MARK: - Networking
    func saveData() {
        if !dataIsValid() { return }
        let user = makeUser(with: uploadUserHeaderViewModel.initialImageUrl)
        
        isLoading.accept(true)
        if let image = uploadUserHeaderViewModel.image.value {
            uploadUserWithNewImage(for: user, image)
        } else {
            uploadUserWithoutNewImage(for: user)
        }
    }
    
    private func uploadUserWithNewImage(for user: UserModel,_ image: UIImage) {
        StoringService.shared.storeProfileImage(image: image).flatMapLatest { [weak self] (imageUrl) -> Observable<UserModel?> in
            user.setImageUrl(imageUrl)
            return UploadingService.shared.saveUser(userProfile: user, shouldUpdate: self?.isUpdating ?? false)
            }.subscribe(onNext: { [weak self] (user) in
                self?.isLoading.accept(false)
                self?.coordinator?.didSetUser.accept(user)
                }, onError: { [weak self] (error) in
                    self?.isLoading.accept(false)
                    if let uploadError = error as? DuelloError {
                        self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                    }
            }).disposed(by: disposeBag)
    }
    
    private func uploadUserWithoutNewImage(for user: UserModel) {
        UploadingService.shared.saveUser(userProfile: user, shouldUpdate: isUpdating).subscribe(onNext: { [weak self] (user) in
            self?.isLoading.accept(false)
            self?.coordinator?.didSetUser.accept(user)
            }, onError: { [weak self] (error) in
                self?.isLoading.accept(false)
                if let uploadError = error as? DuelloError {
                    self?.alert.accept(Alert(alertMessage: uploadError.errorMessage, alertHeader: uploadError.errorHeader))
                }
                
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        
        submitTapped.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.saveData()
        }).disposed(by: disposeBag)
        
        cancelTapped?.asObservable().bind(to: coordinator.canceledUserUpload).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromHeader() {
        uploadUserHeaderViewModel.imageButtonTapped.asObservable().bind(to: showImagePickerView).disposed(by: disposeBag)
    }
}

