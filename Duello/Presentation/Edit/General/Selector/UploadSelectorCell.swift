//
//  UploadSelectorCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadSelectorCell: UITableViewCell {
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = BLACK
        setupLayout()
    }
    
    //MARK: - Views
    var label: UILabel = {
        let label = CustomLabel(width: 0, height: 40)
        label.textColor = LIGHT_GRAY
        label.font = UIFont.mediumCustomFont(size: SMALLFONTSIZE)
        return label
    }()
    
    var switchButton: UISwitch = {
        let sb = UISwitch()
        sb.isOn = false
        return sb
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(switchButton)

        switchButton.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: STANDARDSPACING))
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        label.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: switchButton.leadingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0))
    }
    
    //MARK: - Reactive
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

