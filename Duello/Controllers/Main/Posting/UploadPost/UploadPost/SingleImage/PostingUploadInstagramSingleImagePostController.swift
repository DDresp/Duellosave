//
//  PostingUploadInstagramSingleImagePostController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class PostingUploadInstagramSingleImagePostController: UploadPostTableViewController<UploadInstagramSingleImagePostViewModel> {
    
    //MARK: - Setup
    init(viewModel: UploadInstagramSingleImagePostViewModel) {
        super.init(displayer: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
