//
//  ExploreController.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class ExploreController: ViewController {
    
    //MARK: - ViewModels
    let viewModel: ExploreViewModel
    
    //MARK: - Setup
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        setupNavigationItems()

        viewModel.start()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Explore"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

