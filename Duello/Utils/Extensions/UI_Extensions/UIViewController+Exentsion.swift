//
//  UIViewController+Exentsion.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func presentOneButtonAlert(header: String? = "Alert", message: String? = "", buttonTitle: String, action: (()->())?) {
        
        let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            action?()
        }
        alertController.addAction(action)
        view.endEditing(true)
        present(alertController, animated: true)
        
    }
    
    func presentTwoButtonAlert(header: String, message: String, firstButtonTitle: String, secondButtonTitle: String, firstButtonAction: (()->())?, secondButtonAction: (()->())?) {
        
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: firstButtonTitle, style: .default) { (_) in
            firstButtonAction?()
        }
        
        let actionTwo = UIAlertAction(title: secondButtonTitle, style: .default) { (_) in
            secondButtonAction?()
        }
        
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        
        present(alert, animated: true)
        
    }
    
}
