//
//  UploadHeader.swift
//  Duello
//
//  Created by Darius Dresp on 1/21/21.
//  Copyright © 2021 Darius Dresp. All rights reserved.
//

import UIKit

class UploadSimpleHeader: UIView {
    
    //Variables
    var title: String = "HEADER"
    
    //MARK: - Setup
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumCustomFont(size: EXTREMESMALLFONTSIZE)
        label.textColor = LIGHT_GRAY
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

