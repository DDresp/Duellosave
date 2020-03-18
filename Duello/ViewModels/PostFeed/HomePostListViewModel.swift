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

class HomePostListViewModel: PostListDisplayer {
    
    //MARK: - ChildViewModels
    private var postDisplayers = [PostDisplayer]()
    
    //MARK: - Variables
    var totalPostsCount: Int? //number also includes posts that haven't been loaded so far!
    
    //MARK: - Bindables
    var prefetchingIndexPaths: PublishRelay<[IndexPath]> = PublishRelay<[IndexPath]>()
    var requestNextPosts: PublishRelay<Void> = PublishRelay<Void>()
    
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
   
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var willDisplayCell: PublishRelay<Int> = PublishRelay()
    var didEndDisplayingCell: PublishRelay<Int> = PublishRelay()
    
    var requestedPlayingVideo: PublishRelay<Int> = PublishRelay()
    
    var refreshChanged: PublishSubject<Void> = PublishSubject()
    var restartData: PublishRelay<Void> = PublishRelay()
    var reloadData: PublishRelay<Void> = PublishRelay()
    var updateLayout: PublishRelay<Void> = PublishRelay()
    
    var restart: PublishRelay<Void> = PublishRelay<Void>()
    var finishedStart: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var videosAreMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    //Specific: HomeViewModel
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    var updatePost: PublishRelay<Int> = PublishRelay<Int>()
    var deactivatePost: PublishRelay<String> = PublishRelay<String>()
    //
    
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
    func update(with loadedPosts: [UserPost], totalPostsCount: Int?, fromStart: Bool) {
        
        if fromStart {
            self.totalPostsCount = 0
            postDisplayers = [PostDisplayer]()
            disposeBag = DisposeBag()
            setupBindablesFromOwnProperties()
        }
        
        if let count = totalPostsCount {
            self.totalPostsCount = count
        }
        
        let startIndex = numberOfPostDisplayers
        let endIndex = loadedPosts.count - 1
        
        if startIndex <= endIndex  {
            let newPosts = Array(loadedPosts[startIndex...endIndex])
            configurePostDisplayers(with: newPosts)
        } else {
            self.totalPostsCount = loadedPosts.count
        }
        
        if fromStart {
            restartData.accept(())
        } else {
            reloadData.accept(())
        }
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
        for postDisplayer in newPostDisplayers {
            configurePostDisplayer(for: postDisplayer)
        }
        
        postDisplayers.append(contentsOf: newPostDisplayers)
    
    }
    
    //Configuration of ChildPostViewModels
    private func configurePostDisplayer(for postDisplayer: PostDisplayer) {
        
        postDisplayer.showActionSheet.bind(to: showActionSheet).disposed(by: disposeBag)
        postDisplayer.socialMediaDisplayer.showAdditionalLinkAlert.bind(to: showAdditionalLinkAlert).disposed(by: disposeBag)
        postDisplayer.socialMediaDisplayer.selectedLink.bind(to: loadLink).disposed(by: disposeBag)

        postDisplayer.didExpand.filter { (didExpand) -> Bool in
            return didExpand
        }.map({ (_) -> Void in
            return ()
        }) .bind(to: updateLayout).disposed(by: disposeBag)

        //Specific: HomeViewModel
        postDisplayer.deleteMe.bind(to: deletePost).disposed(by: disposeBag)
        postDisplayer.updateDeactivation.bind(to: updatePost).disposed(by: disposeBag)

        isAppeared.filter { (appeared) -> Bool in
            return !appeared
        }.map { (_) -> () in
            return ()
            }.bind(to: postDisplayer.didDisappear).disposed(by: disposeBag)

        didEndDisplayingCell.asObservable()
            .filter { (index) -> Bool in
                return postDisplayer.index == index }
            .map { (_) -> Void in
                return ()
            }.bind(to: postDisplayer.didDisappear).disposed(by: disposeBag)

        willDisplayCell.asObservable()
            .filter { (index) -> Bool in
                return postDisplayer.index == index }
            .map{ (_) -> Void in
                return ()
            }.bind(to: postDisplayer.willBeDisplayed).disposed(by: disposeBag)

        if let viewModel = postDisplayer as? VideoPostViewModel {
            addConfigurationForVideoPostViewModel(for: viewModel)
        }
        
    }
    
    private func addConfigurationForVideoPostViewModel(for viewModel: VideoPostViewModel) {
        
        //If the sound on/of property changes for one cell, then it should also change for all other cells in the feed
        viewModel.tappedSoundIcon.withLatestFrom(videosAreMuted).map { (isMuted) -> Bool in
            return !isMuted
            }.bind(to: videosAreMuted).disposed(by: disposeBag)
    
        videosAreMuted.bind(to: viewModel.isMuted).disposed(by: disposeBag)
        
        //If one cell plays a video, no other cells should play a video
        viewModel.playVideoRequested.map { (playVideoRequested) -> Int? in
            if playVideoRequested {
                return viewModel.index
            } else {
                return nil
            }
            }.flatMap { (index) -> Observable<Int> in
                return Observable.from(optional: index)
            }.bind(to: requestedPlayingVideo).disposed(by: disposeBag)

        requestedPlayingVideo.filter { (index) -> Bool in
            let requestedPlayingViewModel = viewModel.playVideoRequested.value == true
            let requestedPlayingDifferentViewModel = index != viewModel.index
            return requestedPlayingViewModel && requestedPlayingDifferentViewModel
            }.map({ (_) -> Bool in
                return false
            }).bind(to: viewModel.playVideoRequested).disposed(by: disposeBag)
        
        
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    private func setupBindablesFromOwnProperties() {
        setupBasicBindables()
        
        prefetchingIndexPaths.asObservable().subscribe(onNext: { [weak self] (indexPaths) in
            guard let self = self else { return }
            if indexPaths.contains(where: self.shouldPaginate) {
                self.requestNextPosts.accept(())
            }
        }).disposed(by: disposeBag)
        
    }
    
}
