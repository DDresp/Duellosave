//
//  UserPostViewModel.swift
//  Duello
//
//  Created by Darius Dresp on 4/10/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

//import RxSwift
//import RxCocoa
//
//class UserPostViewModel: PostViewModel {
//    
//    //MARK: - Bindables
//    var deleteMe: PublishRelay<String> = PublishRelay<String>()
//    
//    //MARK: - Getters
//    override func getActions() -> [AlertAction] {
//        var actions = super.getActions()
//    
//        let deleteWarning = ActionWarning(title: "Warning", message: "Do you really want to delete the post?")
//        let deleteAction = AlertAction(title: "Delete", actionWarning: deleteWarning) { [weak self] () in
//            guard let postId = self?.postId else { return }
//            self?.deleteMe.accept(postId)
//        }
//        
//        actions.append(deleteAction)
//        
//        return actions
//    }
//    
//}
