//
//  HoshiTextField+ReactiveExtension.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import TextFieldEffects
import RxSwift
import RxCocoa

extension Reactive where Base: HoshiTextField {
    
    public var borderActiveColor: Binder<UIColor> {
        return Binder(self.base, binding: { (textField, color) in
            textField.borderActiveColor = color
        })
    }
    
}
