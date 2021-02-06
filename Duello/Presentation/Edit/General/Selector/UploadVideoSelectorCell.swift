//
//  UploadPostTypeSelectorCell.swift
//  Duello
//
//  Created by Darius Dresp on 4/2/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadVideoSelectorCell: UploadSelectorCell {
    
    //MARK: - Displayer
    var displayer: UploadRoughMediaSelectorDisplayer? {
        didSet {
            setupBindablesToDisplayer()
        }
    }
    
    //MARK: - Setup
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = "Videos"
    }
    
    //MARK: - Reactive
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        switchButton.rx.isOn.asDriver().drive(displayer.videoIsOn).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
