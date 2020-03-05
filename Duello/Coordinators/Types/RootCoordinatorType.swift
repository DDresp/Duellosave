//
//  RootCoordinatorType.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

protocol RootCoordinatorType: class {
    var presentedController: UIViewController! { get }
    var navigationController: UINavigationController? { get }
}

