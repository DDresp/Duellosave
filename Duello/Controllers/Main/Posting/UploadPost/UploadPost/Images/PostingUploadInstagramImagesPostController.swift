//
//  PostingUploadInstagramImagesPostController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class PostingUploadInstagramImagesPostController: UploadPostTableViewController<UploadInstagramImagesPostViewModel> {
    
    //MARK: - Setup
    init(viewModel: UploadInstagramImagesPostViewModel) {
        super.init(displayer: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

