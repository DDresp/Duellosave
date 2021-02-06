//
//  UploadPostImageTypeSelectorCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadImagesSelectorCell: UploadSelectorCell {
    
    //MARK: - Displayer
    var displayer: UploadRoughMediaSelectorDisplayer? {
        didSet {
            setupBindablesToDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = "Images"
    }
    
    //MARK: - Reactive
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        switchButton.rx.isOn.asDriver().drive(displayer.imagesIsOn).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
