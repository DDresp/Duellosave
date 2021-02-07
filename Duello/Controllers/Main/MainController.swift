//
//  MainController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    
    //MARK: - Coordinator
    weak var coordinator: MainCoordinatorType?
    
    //MARK: - ViewModel
    let viewModel: MainViewModel
    
    //MARK: - Setup
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainController {
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .fullScreen
        }
        
        set {
            return super.modalPresentationStyle = newValue
        }
    }
    
}
