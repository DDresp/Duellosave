//
//  AuthenticationHeader.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class AuthenticationHeader: UIView {
    
    //MARK: - Displayer
    var displayer: AuthenticationDisplayer!
    
    //MARK: - Variables
    weak var parentViewController: UIViewController!
    
    //MARK: - Setup
    convenience init(parentViewController: UIViewController, displayer: AuthenticationDisplayer) {
        self.init()
        self.parentViewController = parentViewController
        self.displayer = displayer
        backgroundColor = ULTRADARKCOLOR
        setupLayout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    private let duelloLabel: UILabel = {
        let label = UILabel()
        label.text = "Duello"
        label.font = UIFont.boldCustomFont(size: EXTREMELARGEFONTSIZE)
        label.textColor = LIGHTFONTCOLOR
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        addSubview(duelloLabel)
        duelloLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 35, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
