//
//  EmptyCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: - Views
    let label: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Welcome to Duello\n", attributes: [NSAttributedString.Key.font : UIFont.boldCustomFont(size: LARGEFONTSIZE), NSAttributedString.Key.foregroundColor: DARKGRAYCOLOR])
        let nextAttributedString = NSAttributedString(string: "You haven't created any posts, yet", attributes: [NSAttributedString.Key.font: UIFont.mediumCustomFont(size: MEDIUMFONTSIZE), NSAttributedString.Key.foregroundColor: LIGHTGRAYCOLOR])
        attributedString.append(nextAttributedString)
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = VERYLIGHTGRAYCOLOR
        return view
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(emptyView)
        emptyView.fillSuperview()
        
        emptyView.addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
