//
//  HomeUpdateUserController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class HomeUpdateUserController: UploadUserTableViewController<UpdateUserViewModel> {
    
    //MARK: - Setup
    init(viewModel: UpdateUserViewModel) {
        super.init(displayer: viewModel)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
