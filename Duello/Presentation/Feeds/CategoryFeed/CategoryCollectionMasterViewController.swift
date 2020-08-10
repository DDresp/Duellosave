//
//  CategoryFeedViewController.swift
//  Duello
//
//  Created by Darius Dresp on 4/5/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

class CategoryCollectionMasterViewController: ViewController {
    
    //MARK: - Displayer
    let displayer: CategoryCollectionMasterDisplayer
    
    //MARK: - Setup
    init(displayer: CategoryCollectionMasterDisplayer) {
        self.displayer = displayer
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


