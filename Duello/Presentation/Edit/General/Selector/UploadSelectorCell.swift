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
        backgroundColor = .white
        setupLayout()
    }
    
    //MARK: - Views
    var label: UILabel = {
        let label = UILabel()
        label.textColor = STRONGFONTCOLOR
        label.font = UIFont.mediumCustomFont(size: MEDIUMFONTSIZE)
        return label
    }()
    
    var switchButton: UISwitch = {
        let videoSwitch = UISwitch()
        videoSwitch.isOn = false
        return videoSwitch
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(switchButton)
        label.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0), size: .init(width: 0, height: 30))
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: STANDARDSPACING), size: .init(width: 60, height: 30))
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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

