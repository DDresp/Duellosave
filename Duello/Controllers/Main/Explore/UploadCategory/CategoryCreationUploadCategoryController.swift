//
//  CategoryCreationUploadCategoryController.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//
import UIKit

class CategoryCreationUploadCategoryController: UploadCategoryController<UploadCategoryViewModel> {
    
    //MARK: - Setup
    init(viewModel: UploadCategoryViewModel) {
        super.init(displayer: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

