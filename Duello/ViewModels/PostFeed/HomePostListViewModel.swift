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
    
    //MARK: - Bindables
    var loadLink: PublishRelay<String?> = PublishRelay<String?>()
    var showAdditionalLinkAlert: PublishRelay<String> = PublishRelay<String>()
    var showActionSheet: PublishRelay<ActionSheet> = PublishRelay<ActionSheet>()
   
    var isAppeared: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var willDisplayCell: PublishRelay<Int> = PublishRelay()
    var didEndDisplayingCell: PublishRelay<Int> = PublishRelay()
    
    var requestedPlayingVideo: PublishRelay<Int> = PublishRelay()

    var reload: PublishRelay<Void> = PublishRelay()
    var insert: PublishRelay<(Int, Int)> = PublishRelay()
    var updateLayout: PublishRelay<Void> = PublishRelay()
    
    var videosAreMuted: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    //Specific: HomeViewModel
    var deletePost: PublishRelay<String> = PublishRelay<String>()
    var updatePost: PublishRelay<Int> = PublishRelay<Int>()
    var deactivatePost: PublishRelay<String> = PublishRelay<String>()
    //
    
    //MARK: - Getters
    var numberOfPostDisplayers: Int { return postDisplayers.count }
    
    func getPostDisplayer(at index: Int) -> PostDisplayer? {
        guard index < numberOfPostDisplayers else { return nil }
        return postDisplayers[index]
    }
    
    //MARK: - Methods
    func update(with loadedPosts: [PostModel], fromStart: Bool) {
        
        if fromStart {
            postDisplayers = [PostDisplayer]()
            disposeBag = DisposeBag()
        }
        
        if numberOfPostDisplayers == 0 && loadedPosts.count == 0 {
            reload.accept(())
            return
        }
        
        let startIndex = numberOfPostDisplayers
        let endIndex = loadedPosts.count - 1
        
        guard startIndex <= endIndex else { return }
        
        let newPosts = Array(loadedPosts[startIndex...endIndex])
        configurePostDisplayers(with: newPosts)

        if fromStart {
            reload.accept(())
        } else {
            insert.accept((startIndex, endIndex))
        }
    }
    
    //Configuration
    private func configurePostDisplayers(with posts: [PostModel]) {
        
        let startIndex = postDisplayers.count
        var newPostDisplayers = [PostDisplayer]()
        
        for (index, post) in posts.enumerated() {
            
            var viewModel: PostDisplayer?
            let modelIndex = startIndex + index
            
            switch post {
            case let model as SingleImagePostModel:
                viewModel = SingleImagePostViewModel(post: model, index: modelIndex)
            case let model as ImagesPostModel:
                viewModel = ImagesPostViewModel(post: model, index: modelIndex)
            case let model as VideoPostModel:
                viewModel = VideoPostViewModel(post: model, index: modelIndex)
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
    
}
