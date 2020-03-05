//
//  MainController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Firebase
import RxCocoa
import RxSwift

class MainController: UITabBarController {
    
    //MARK: - Coordinator
    weak var coordinator: MainCoordinatorType?
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
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
