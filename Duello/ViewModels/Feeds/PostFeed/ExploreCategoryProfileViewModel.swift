//
//  CategoryProfileViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/6/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class ExploreCategoryProfileViewModel: SimplePostCollectionMasterViewModel {
    
    //MARK: - Coordinator
    weak var coordinator: CategoryProfileCoordinatorType? {
        didSet {
            setupBindablesToCoordinator()
        }
    }
    
    //MARK: - Models
    var category: CategoryModel
    
    //MARK: - View Model
    var collectionViewModel: CategoryPostCollectionViewModel {
        return postCollectionDisplayer as! CategoryPostCollectionViewModel
    }
    
    //MARK: - Bindables
    let tappedAddContent: PublishRelay<Void> = PublishRelay()
    let tappedEllipsis: PublishRelay<Void> = PublishRelay()
    let tappedReport: PublishRelay<Void> = PublishRelay()
    let tappedGoBack: PublishRelay<Void> = PublishRelay()
    var isFavorite: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
    //MARK: - Setup
    init(category: CategoryModel) {
        self.category = category
        super.init(postCollectionDisplayer: CategoryPostCollectionViewModel(), fetchSteps: 6) { (limit, startId) -> Observable<[PostModel]> in
            return FetchingService.shared.fetchCategoryPosts(for: category.getId(), limit: limit, startId: startId)
        }
    }
    
    //MARK: - Methods
    override func start() {
        super.start()
        collectionViewModel.category.accept(category)
        fetchCategoryFavoriteStatus()
    }
    
    func fetchCategoryFavoriteStatus() {
        
        guard let categoryId = category.id else { return }
        
        DispatchQueue.global(qos: .background).async  {
            
            FetchingService.shared.fetchFavoriteStatus(for: categoryId).subscribe(onNext: { [weak self] (isFavorite) in
                self?.isFavorite.accept(isFavorite)
            }).disposed(by: self.disposeBag)
            
        }
        
    }
    
    //MARK: - Networking
    func reportPost(for postId: String, report: PostReportStatusEnum) {
        UploadingService.shared.createPostReport(postId: postId, report: report).subscribe(onNext: { (_) in
            //created report
            }).disposed(by: disposeBag)
    }
    
    func reportCategory(report: CategoryReportStatusEnum) {
        UploadingService.shared.createCategoryReport(categoryId: category.getId(), report: report).subscribe(onNext: { (_) in
            //created report
        }).disposed(by: disposeBag)
    }
    
    func changeFavoriteStatus() {
        
        guard let categoryId = category.id, let favorite = isFavorite.value else { return }
        if favorite {
            isFavorite.accept(!favorite)
            DeletingService.shared.unfavorCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //unfavored category
                }).disposed(by: disposeBag)
        } else {
            isFavorite.accept(!favorite)
            UploadingService.shared.favorCategory(categoryId: categoryId).subscribe(onNext: { (_) in
                //favored category
            }).disposed(by: disposeBag)
        }
        
    }
    
    //MARK: - Reactive
    override func setupBindables() {
        super.setupBindables()
        setupBindablesFromUI()
    }
    
    func setupBindablesFromUI() {
        
        tappedEllipsis.map { [weak self] (_) -> ActionSheet in
            var actions = [AlertAction]()
            
            let reportAction = AlertAction(title: "Report") { [weak self] () in
                self?.tappedReport.accept(())
            }
            
            actions.append(reportAction)
            let actionSheet = ActionSheet(actionHeader: nil, actionMessage: "select option", actions: actions)
            return actionSheet
        }.bind(to: showActionSheet).disposed(by: disposeBag)
        
        tappedReport.subscribe(onNext: { [weak self] (_) in
            var actions = [AlertAction]()
            let thankYouAlert = Alert(alertMessage: "Thank you for your report!", alertHeader: "Reported")
            
            let inappropriateReport = AlertAction(title: "Inappropriate Category") {
                self?.reportCategory(report: CategoryReportStatusEnum.inappropriate)
                self?.showAlert.accept(thankYouAlert)
            }
            let inactiveReport = AlertAction(title: "Inactive") {
                self?.reportCategory(report: CategoryReportStatusEnum.inactive)
                self?.showAlert.accept(thankYouAlert)
            }
            
            actions.append(contentsOf: [inappropriateReport, inactiveReport])
            
            let actionSheet = ActionSheet(actionHeader: "report", actionMessage: nil, actions: actions)
            self?.showActionSheet.accept(actionSheet)
        }).disposed(by: disposeBag)
    }
    
    override func setupBindblesFromChildDisplayer() {
        super.setupBindblesFromChildDisplayer()
        
        collectionViewModel.reportPost.subscribe(onNext: { [weak self] (report, postId) in
            self?.reportPost(for: postId, report: report)
            }).disposed(by: disposeBag)
        
        collectionViewModel.changeFavoriteStatus.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.changeFavoriteStatus()
            }).disposed(by: disposeBag)
        
    }
    
    override func setupBindablesToChildDisplayer() {
        super.setupBindablesToChildDisplayer()
        isFavorite.bind(to: collectionViewModel.isFavorite).disposed(by: disposeBag)
    }
    
    private func setupBindablesToCoordinator() {
        guard let coordinator = coordinator else { return }
        tappedAddContent.bind(to: coordinator.requestedAddContent).disposed(by: disposeBag)
        tappedGoBack.bind(to: coordinator.goBack).disposed(by: disposeBag)
    }
    
}
