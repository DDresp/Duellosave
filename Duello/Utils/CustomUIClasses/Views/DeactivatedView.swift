//
//  DeactivatedView.swift
//  Duello
//
//  Created by Darius Dresp on 3/17/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class DeactivatedView: UIView {
    
    var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Post is Deactivated"
        label.font = UIFont.boldCustomFont(size: LARGEFONTSIZE)
        label.textColor = VERYLIGHTGRAYCOLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DARKGRAYCOLOR
        
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
