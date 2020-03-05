//
//  PostCollectionViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class PostCollectionViewModel: PostCollectionDisplayer {
    
    //MARK: - ChildViewModels
    private var postDisplayers = [PostDisplayer]()
    
    //MARK: - Variables
    var totalPostsCount: Int? //number also includes posts that haven't been loaded so far!
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var updateLayout: PublishRelay<Bool> = PublishRelay<Bool>()
    var prefetchingIndexPaths: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    var needsUpdate: PublishRelay<Void> = PublishRelay<Void>()
    var deleteItem: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
    var didEndDisplayingCell: PublishRelay<Int> = PublishRelay()
    var viewDidDisappear: PublishRelay<Void> = PublishRelay()
    var startPlayingVideo: PublishRelay<Int> = PublishRelay()
    var willDisplayCell: PublishRelay<Int> = PublishRelay()
    
    //MARK: - Setup
    init() {
        setupBindablesFromOwnProperties()
    }
    
    //MARK: - Getters
    var numberOfPostDisplayers: Int { return postDisplayers.count }
    
    var noPostsAvailable: Bool { return totalPostsCount == 0 }
    var loadedAllPosts: Bool {
        return (totalPostsCount == numberOfPostDisplayers) && numberOfPostDisplayers > 0
    }
    
    func getPostDisplayer(at index: Int) -> PostDisplayer? {
        guard index < numberOfPostDisplayers else { return nil }
        return postDisplayers[index]
    }

    private func shouldPaginate(indexPath: IndexPath) -> Bool {
        guard let totalCount = totalPostsCount else { return false }
        let notAtTotalEnd = (numberOfPostDisplayers < totalCount)
        let closeToCurrrentEnd = indexPath.row == numberOfPostDisplayers - 2
        return notAtTotalEnd && closeToCurrrentEnd
    }
    
    //MARK: - Methods
    func update(with loadedPosts: [UserPost], totalPostsCount: Int?) {
        if let count = totalPostsCount {
            self.totalPostsCount = count
        }
        let startIndex = numberOfPostDisplayers
        let endIndex = loadedPosts.count - 1
        guard startIndex <= endIndex else { return self.totalPostsCount = loadedPosts.count }
        
        let newPosts = Array(loadedPosts[startIndex...endIndex])
        configurePostDisplayers(with: newPosts)
    }
    
    //Configuration
    private func configurePostDisplayers(with userPosts: [UserPost]) {
        
        let startIndex = postDisplayers.count
        var newPostDisplayers = [PostDisplayer]()
        
        for (index, userPost) in userPosts.enumerated() {
            let user = userPost.0
            let post = userPost.1
            
            var viewModel: PostDisplayer?
            let modelIndex = startIndex + index
            
            switch post {
            case let model as SingleImagePostModel:
                viewModel = SingleImagePostViewModel(user: user, post: model, index: modelIndex)
            case let model as ImagesPostModel:
                viewModel = ImagesPostViewModel(user: user, post: model, index: modelIndex)
            case let model as VideoPostModel:
                viewModel = VideoPostViewModel(user: user, post: model, index: modelIndex)
            default:
                ()
            }
            if let viewModel = viewModel {
                newPostDisplayers.append(viewModel)
            }
        }
        for viewModel in newPostDisplayers {
            configurePostDisplayer(for: viewModel)
        }
        postDisplayers.append(contentsOf: newPostDisplayers)

    }
    
    //Configuration of ChildPostViewModels
    private func configurePostDisplayer(for viewModel: PostDisplayer) {
        
        viewModel.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        viewModel.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)
        viewModel.didExpand.asObservable().bind(to: updateLayout).disposed(by: disposeBag)
        viewModel.showActionSheet.asObservable().bind(to: showActionSheet).disposed(by: disposeBag)
        
        viewDidDisappear.asObservable().bind(to: viewModel.viewDidDisappear).disposed(by: disposeBag)
        
        viewModel.deleteMe.asObservable()
            .map { [weak self] (index) -> String in
                guard let postViewModel = self?.getPostDisplayer(at: index) else { return "" }
                return postViewModel.postId
            }.filter { (postId) -> Bool in
                return postId.count > 0
            }.bind(to: deleteItem).disposed(by: disposeBag)
        
        didEndDisplayingCell.asObservable()
            .filter { (index) -> Bool in
                return viewModel.index == index }
            .map { (_) -> Void in
                return ()
            }.bind(to: viewModel.didEndDisplaying).disposed(by: disposeBag)
        
        willDisplayCell.asObservable()
            .filter { (index) -> Bool in
                return viewModel.index == index }
            .map{ (_) -> Void in
                return ()
            }.bind(to: viewModel.willBeDisplayed).disposed(by: disposeBag)
        
        if let viewModel = viewModel as? VideoPostViewModel {
            addConfigurationForVideoPostViewModel(for: viewModel)
        }
        
    }
    
    private func addConfigurationForVideoPostViewModel(for viewModel: VideoPostViewModel) {
        
        viewModel.playVideoRequested.asObservable().map { (playVideo) -> Int? in
            if playVideo {
                return viewModel.index
            } else {
                return nil
            }
            }.flatMap { (index) -> Observable<Int> in
                return Observable.from(optional: index)
            }.bind(to: startPlayingVideo).disposed(by: disposeBag)
        
        
        startPlayingVideo.asObservable().filter { (index) -> Bool in
            return index != viewModel.index
            }.map({ (_) -> Bool in
                return false
            }).bind(to: viewModel.playVideoRequested).disposed(by: disposeBag)
        
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        prefetchingIndexPaths.asObservable().subscribe(onNext: { [weak self] (indexPaths) in
            guard let self = self else { return }
            if indexPaths.contains(where: self.shouldPaginate) {
                self.needsUpdate.accept(())
            }
        }).disposed(by: disposeBag)
        
    }
    
}
