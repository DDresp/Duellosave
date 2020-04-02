//
//  CategoryCreationViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class CategoryCreationViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: CategoryCreationCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Bindables
    var creationButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    
    //MARK: - Reactive
    private let disposeBag = DisposeBag()
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        creationButtonTapped.bind(to: coordinator.requestedCategoryUpload).disposed(by: disposeBag)
    }
}
