//
//  UploadPostImageTypeSelectorCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class UploadPostImageSelectorCell: UITableViewCell {
    
    //MARK: - Displayer
    var displayer: UploadPostTypeSelectorDisplayer? {
        didSet {
            setupBindablesToDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupLayout()
    }
    
    //MARK: - Views
    private var imagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Images"
        label.textColor = DARKGRAYCOLOR
        label.font = UIFont.mediumCustomFont(size: MEDIUMFONTSIZE)
        return label
    }()
    
    private var imagesSwitch: UISwitch = {
        let imagesSwitch = UISwitch()
        imagesSwitch.isOn = false
        return imagesSwitch
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(imagesLabel)
        contentView.addSubview(imagesSwitch)
        imagesLabel.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: STANDARDSPACING, left: STANDARDSPACING, bottom: STANDARDSPACING, right: 0), size: .init(width: 0, height: 30))
        imagesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imagesSwitch.anchor(top: nil, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: STANDARDSPACING), size: .init(width: 60, height: 30))
        imagesSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        imagesSwitch.rx.isOn.asDriver().drive(displayer.imagesIsOn).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
