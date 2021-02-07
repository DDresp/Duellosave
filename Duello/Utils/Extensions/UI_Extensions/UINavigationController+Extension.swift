//
//  UINavigationController+Extension.swift
//  Duello
//
//  Created by Darius Dresp on 2/7/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
