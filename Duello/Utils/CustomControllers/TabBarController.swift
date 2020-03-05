//
//  TabBarController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController  {
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .fullScreen
        }
        
        set {
            return super.modalPresentationStyle = newValue
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}

